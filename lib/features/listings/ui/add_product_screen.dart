import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/upload_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/tag_input_field.dart';
import '../bloc/listings_cubit.dart';
import '../data/listings_repository.dart';
import '../../vendor/data/vendor_repository.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool _isForRent = false;
  final Set<String> _selectedSizes = {};
  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _perDayController = TextEditingController();
  final _depositController = TextEditingController();
  final _durationController = TextEditingController();

  // Product photos — uploaded to the API; up to 4.
  final _picker = ImagePicker();
  final _uploads = UploadService();
  final List<String?> _imageSlots = List<String?>.filled(4, null, growable: false);
  final List<bool> _uploadingSlots = List<bool>.filled(4, false, growable: false);

  Future<void> _pickPhoto(int index) async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() => _uploadingSlots[index] = true);
      final bytes = await picked.readAsBytes();
      final url = await _uploads.uploadListingImage(bytes, picked.name);
      if (!mounted) return;
      setState(() {
        _imageSlots[index] = url;
        _uploadingSlots[index] = false;
      });
    } catch (e) {
      if (mounted) setState(() => _uploadingSlots[index] = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    }
  }
  final _skuController = TextEditingController();
  final _quantityController = TextEditingController();
  List<String> _tags = [];
  bool _publishing = false;

  // Categories (admin-managed), limited to the vendor's registered ones.
  List<CategoryOption> _apiCategories = [];
  List<String> _vendorTags = [];
  String? _selectedCategory;

  List<CategoryOption> get _pickableCategories => _vendorTags.isEmpty
      ? _apiCategories
      : _apiCategories.where((c) => _vendorTags.contains(c.name)).toList();

  double? _parseAmount(String text) =>
      double.tryParse(text.replaceAll(',', '').trim());

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFieldChanged);
    _descController.addListener(_onFieldChanged);
    ListingsRepository().categories().then((cats) {
      if (mounted) setState(() => _apiCategories = cats);
    }).catchError((_) {});
    VendorRepository().getMe().then((v) {
      if (mounted && v != null) {
        setState(() => _vendorTags = List<String>.from(v.tags));
      }
    }).catchError((_) {});
  }

  void _onFieldChanged() => setState(() {});

  /// Submit is enabled only once the mandatory fields are filled.
  bool get _canPublish =>
      _nameController.text.trim().isNotEmpty &&
      _descController.text.trim().isNotEmpty &&
      _selectedCategory != null;

  /// Builds a unique SKU from the product name (required) + a category/tag
  /// prefix + a time-based suffix. Requires the name to be entered first.
  void _generateSku() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Enter the product name first, then generate an SKU.')),
      );
      return;
    }
    String part(String s, int n) {
      final cleaned = s.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
      return cleaned.isEmpty
          ? 'X' * n
          : cleaned.padRight(n, 'X').substring(0, n);
    }

    final tagPart = _tags.isNotEmpty ? part(_tags.first, 3) : 'GEN';
    final namePart = part(name, 3);
    final suffix = (DateTime.now().millisecondsSinceEpoch % 100000)
        .toString()
        .padLeft(5, '0');
    setState(() => _skuController.text = '$tagPart-$namePart-$suffix');
  }

  Future<void> _publish() async {
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    if (name.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product name and description are required')),
      );
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }
    setState(() => _publishing = true);
    try {
      final repo = ListingsRepository();
      final cats =
          _apiCategories.isNotEmpty ? _apiCategories : await repo.categories();
      if (cats.isEmpty) throw Exception('No categories available');
      final match = cats.firstWhere(
        (c) => c.name == _selectedCategory,
        orElse: () => cats.first,
      );
      final listing = await repo.create(
        categoryId: match.id,
        title: name,
        description: desc,
        pricingType: 'FIXED',
        basePrice: _parseAmount(_priceController.text),
        isRentable: _isForRent,
        perDayRate: _isForRent ? _parseAmount(_perDayController.text) : null,
        depositAmount: _isForRent ? _parseAmount(_depositController.text) : null,
        sku: _skuController.text.trim().isEmpty
            ? null
            : _skuController.text.trim(),
        stockQuantity: int.tryParse(_quantityController.text.trim()),
        tags: _tags,
        mediaUrls: _imageSlots.whereType<String>().toList(),
      );
      if (!mounted) return;
      context.read<ListingsCubit>().load();
      context.pushReplacement(
        '/listings/add-success',
        extra: {
          'isService': false,
          'productId': listing.id,
          'sku': _skuController.text.trim(),
          'tags': _tags,
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _perDayController.dispose();
    _depositController.dispose();
    _durationController.dispose();
    _skuController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: GoogleFonts.urbanist(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: context.c.textPrimary,
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return GestureDetector(
      onTap: _showCategoryBottomSheet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.c.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: context.c.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedCategory ?? 'Select a category',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: _selectedCategory != null
                          ? context.c.textPrimary
                          : context.c.textHint,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.c.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Text(
                    'Select Category',
                    style: GoogleFonts.urbanist(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: _apiCategories.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(28),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : _pickableCategories.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                "You haven't added any categories to your profile yet. "
                                'Add them under Profile → Business Details to list products here.',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: context.c.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            )
                          : ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 12),
                              children: _pickableCategories
                                  .map(
                                    (cat) => ListTile(
                                      title: Text(
                                        cat.name,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 15,
                                          color: context.c.textPrimary,
                                        ),
                                      ),
                                      trailing: _selectedCategory == cat.name
                                          ? const Icon(Icons.check_rounded,
                                              color: AppColors.primary)
                                          : null,
                                      onTap: () {
                                        setState(
                                            () => _selectedCategory = cat.name);
                                        Navigator.pop(ctx);
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          size: 16, color: context.c.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Only your registered categories are shown. Add more in '
                          'Profile → Business Details.',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: context.c.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleTabs() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: context.c.divider,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildToggleTab('For Sale', !_isForRent, () {
            setState(() => _isForRent = false);
          }),
          _buildToggleTab('For Rent', _isForRent, () {
            setState(() => _isForRent = true);
          }),
        ],
      ),
    );
  }

  Widget _buildToggleTab(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? context.c.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.primary : context.c.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoBox(int index, String label) {
    final url = _imageSlots[index];
    final uploading = _uploadingSlots[index];
    return GestureDetector(
      onTap: uploading ? null : () => _pickPhoto(index),
      child: Container(
        height: 90,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.c.divider,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.c.border,
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: uploading
            ? const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.primary),
                ),
              )
            : url != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(url, fit: BoxFit.cover),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => _imageSlots[index] = null),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_rounded,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppIcon('gallery',
                          size: 24, color: context.c.textHint),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          color: context.c.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildSizesRow() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _sizes.map((size) {
        final isSelected = _selectedSizes.contains(size);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedSizes.remove(size);
              } else {
                _selectedSizes.add(size);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 48,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : context.c.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : context.c.border,
              ),
            ),
            child: Center(
              child: Text(
                size,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : context.c.textSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.surface,
      appBar: AppBar(
        backgroundColor: context.c.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.c.divider,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: context.c.textPrimary,
              size: 20,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add a Product',
              style: GoogleFonts.urbanist(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
              ),
            ),
            Text(
              'Add a product to your catalogue',
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: context.c.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildToggleTabs(),
                  const SizedBox(height: 24),
                  AppInput(
                    label: 'Product Name',
                    hint: 'Enter product name...',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  AppInput(
                    label: 'Product Description',
                    hint: 'Describe your product...',
                    controller: _descController,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),
                  const SizedBox(height: 16),
                  _buildCategorySelector(),
                  const SizedBox(height: 16),
                  AppInput(
                    label: 'Product Price',
                    hint: '0',
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    prefixText: '₦',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  if (_isForRent) ...[
                    const SizedBox(height: 16),
                    AppInput(
                      label: 'Price Per Day',
                      hint: '0',
                      controller: _perDayController,
                      keyboardType: TextInputType.number,
                      prefixText: '₦',
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 16),
                    AppInput(
                      label: 'Refundable Deposit',
                      hint: '0',
                      controller: _depositController,
                      keyboardType: TextInputType.number,
                      prefixText: '₦',
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 16),
                    AppInput(
                      label: 'Rental Duration (days)',
                      hint: 'e.g. 3',
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ],
                  const SizedBox(height: 16),
                  AppInput(
                    label: 'SKU',
                    hint: 'Enter product SKU...',
                    controller: _skuController,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _generateSku,
                      icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                      label: const Text('Generate for me'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        textStyle: GoogleFonts.urbanist(
                            fontSize: 13, fontWeight: FontWeight.w700),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppInput(
                    label: 'Quantity in Stock',
                    hint: 'How many do you have in stock',
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Available Sizes (Optional)'),
                  _buildSizesRow(),
                  const SizedBox(height: 20),
                  TagInputField(
                    tags: _tags,
                    label: 'Tags',
                    hint: 'e.g. Wedding, Cake, Luxury',
                    onChanged: (updated) => setState(() => _tags = updated),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Product Photos'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.0,
                    children: [
                      _buildPhotoBox(0, 'Front Photo'),
                      _buildPhotoBox(1, 'Back Photo'),
                      _buildPhotoBox(2, 'Side Photo'),
                      _buildPhotoBox(3, 'Detail Photo'),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: BoxDecoration(
              color: context.c.surface,
              border: Border(
                top: BorderSide(color: context.c.border),
              ),
            ),
            child: AppButton.primary(
              _publishing ? 'Publishing…' : 'Publish Product',
              loading: _publishing,
              onTap: (_publishing || !_canPublish) ? null : _publish,
            ),
          ),
        ],
      ),
    );
  }
}
