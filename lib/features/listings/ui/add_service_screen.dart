import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/upload_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/tag_input_field.dart';
import '../bloc/listings_cubit.dart';
import '../data/listings_repository.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  List<String> _tags = [];
  final _durationValueController = TextEditingController(text: '1');
  bool _publishing = false;

  Future<void> _publish() async {
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    if (name.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service name and description are required')),
      );
      return;
    }
    setState(() => _publishing = true);
    try {
      final repo = ListingsRepository();
      final cats = await repo.categories();
      if (cats.isEmpty) throw Exception('No categories available');
      // Match the picked category name against API categories; fall back to
      // a tag match, then the first category.
      final picked = (_selectedCategory ?? '').toLowerCase();
      final match = cats.firstWhere(
        (c) =>
            picked.isNotEmpty &&
            (c.name.toLowerCase().contains(picked) ||
                picked.contains(c.name.toLowerCase())),
        orElse: () => cats.firstWhere(
          (c) => _tags.any((t) =>
              c.name.toLowerCase().contains(t.toLowerCase()) ||
              t.toLowerCase().contains(c.name.toLowerCase())),
          orElse: () => cats.first,
        ),
      );
      final startPrice = _priceRange.start;
      final listing = await repo.create(
        categoryId: match.id,
        title: name,
        description: desc,
        pricingType: startPrice > 0 ? 'STARTING_FROM' : 'QUOTE',
        basePrice: startPrice > 0 ? startPrice : null,
        tags: _tags,
        mediaUrls: _imageSlots.whereType<String>().toList(),
      );
      if (!mounted) return;
      context.read<ListingsCubit>().load();
      context.pushReplacement(
        '/listings/add-success',
        extra: {'isService': true, 'productId': listing.id, 'tags': _tags},
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

  String? _selectedCategory;
  String _selectedCancellationPolicy = '';
  String _durationUnit = 'Hours';
  RangeValues _priceRange = const RangeValues(0, 500000);

  // Categories come from the backend (managed in the admin console).
  List<CategoryOption> _apiCategories = [];

  // Service photos — uploaded to the API; up to 4.
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

  final List<String> _cancellationPolicies = ['Flexible', 'Moderate', 'Strict'];
  final List<String> _durationUnits = ['Days', 'Hours', 'Mins'];

  @override
  void initState() {
    super.initState();
    ListingsRepository().categories().then((cats) {
      if (mounted) setState(() => _apiCategories = cats);
    }).catchError((_) {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _durationValueController.dispose();
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
          color: AppColors.textPrimary,
        ),
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
                      color: AppColors.textPrimary,
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
                      : ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 12),
                          children: _apiCategories
                              .map(
                                (cat) => ListTile(
                                  title: Text(
                                    cat.name,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 15,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  trailing: _selectedCategory == cat.name
                                      ? const Icon(Icons.check_rounded,
                                          color: AppColors.primary)
                                      : null,
                                  onTap: () {
                                    setState(() => _selectedCategory = cat.name);
                                    Navigator.pop(ctx);
                                  },
                                ),
                              )
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCancellationPolicyBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  'Cancellation Policy',
                  style: GoogleFonts.urbanist(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Divider(height: 1),
              ..._cancellationPolicies.map(
                (policy) => ListTile(
                  title: Text(
                    policy,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing: _selectedCancellationPolicy == policy
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.primary,
                        )
                      : null,
                  onTap: () {
                    setState(() => _selectedCancellationPolicy = policy);
                    Navigator.pop(ctx);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
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
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
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
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.primaryLight,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.12),
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 10,
            ),
            trackHeight: 4,
          ),
          child: RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000000,
            divisions: 100,
            activeColor: AppColors.primary,
            onChanged: (values) {
              setState(() => _priceRange = values);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildPriceDisplay('Min', _priceRange.start.round()),
            ),
            const SizedBox(width: 12),
            Expanded(child: _buildPriceDisplay('Max', _priceRange.end.round())),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceDisplay(String label, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '₦',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatNumber(value),
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(value % 1000000 == 0 ? 0 : 1)}M';
    } else if (value >= 1000) {
      final s = value.toString();
      final result = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) result.write(',');
        result.write(s[i]);
      }
      return result.toString();
    }
    return value.toString();
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Duration',
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        // Pill chips row
        Row(
          children: _durationUnits.map((unit) {
            final isSelected = _durationUnit == unit;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _durationUnit = unit),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    unit,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        // Duration value input
        AppInput(
          hint: 'Enter duration value...',
          controller: _durationValueController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ],
    );
  }

  Widget _buildCancellationPolicy() {
    return GestureDetector(
      onTap: _showCancellationPolicyBottomSheet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cancellation Policy',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedCancellationPolicy.isEmpty
                        ? 'Select a policy'
                        : _selectedCancellationPolicy,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: _selectedCancellationPolicy.isNotEmpty
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ],
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
          color: AppColors.primaryLight.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
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
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        color: AppColors.primary.withValues(alpha: 0.6),
                        size: 26,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add a Service',
                    style: GoogleFonts.urbanist(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Add a service for your business',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                  AppInput(
                    label: 'Service Name',
                    hint: 'Enter service name...',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 16),
                  AppInput(
                    label: 'Service Description',
                    hint: 'Describe your service...',
                    controller: _descController,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                  ),
                  const SizedBox(height: 16),
                  _buildCategorySelector(),
                  const SizedBox(height: 16),
                  _buildPriceRange(),
                  const SizedBox(height: 16),
                  _buildDurationSelector(),
                  const SizedBox(height: 16),
                  _buildCancellationPolicy(),
                  const SizedBox(height: 16),
                  TagInputField(
                    tags: _tags,
                    label: 'Tags',
                    hint: 'e.g. Wedding, Photography, Outdoor',
                    onChanged: (updated) => setState(() => _tags = updated),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionTitle('Service Photos'),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.0,
                    children: [
                      _buildPhotoBox(0, 'Photo 1'),
                      _buildPhotoBox(1, 'Photo 2'),
                      _buildPhotoBox(2, 'Photo 3'),
                      _buildPhotoBox(3, 'Photo 4'),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: AppButton.primary(
              _publishing ? 'Publishing…' : 'Publish Service',
              loading: _publishing,
              onTap: _publishing ? null : _publish,
            ),
          ),
        ],
      ),
    );
  }
}
