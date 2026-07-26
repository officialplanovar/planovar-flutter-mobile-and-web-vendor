import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/responsive.dart';
import '../../../shared/widgets/app_icon.dart';
import '../bloc/listings_cubit.dart';
import '../data/listings_repository.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/tag_input_field.dart';
import '../../../shared/widgets/network_image_widget.dart';

class EditListingScreen extends StatefulWidget {
  final String listingId;

  const EditListingScreen({super.key, required this.listingId});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  late ListingModel listing;

  // Common controllers
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  List<String> _tags = [];

  // Product controllers
  late TextEditingController _priceCtrl;
  late TextEditingController _perDayCtrl;
  late TextEditingController _depositCtrl;
  late TextEditingController _durationCtrl;
  late TextEditingController _skuCtrl;
  late TextEditingController _quantityCtrl;

  // Service controllers
  late TextEditingController _minPriceCtrl;
  late TextEditingController _maxPriceCtrl;
  late TextEditingController _durationDaysCtrl;
  late TextEditingController _durationHoursCtrl;
  late TextEditingController _durationMinsCtrl;

  // Product state
  bool _isForRent = false;
  final Set<String> _selectedSizes = {};
  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL'];

  // Service state
  String? _selectedCategory;
  String _selectedCancellationPolicy = 'Flexible';
  RangeValues _priceRange = const RangeValues(0, 500000);

  // Categories from the backend (admin-managed).
  List<CategoryOption> _apiCategories = [];
  List<String> get _apiCategoryNames =>
      _apiCategories.map((c) => c.name).toList();

  static const _durationUnits = ['Days', 'Hours', 'Mins'];
  final List<String> _cancellationPolicies = ['Flexible', 'Moderate', 'Strict'];

  bool get _isService =>
      listing.pricingType != 'FIXED' && !listing.isRentable;

  static const _gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    ),
  );

  @override
  void initState() {
    super.initState();
    ListingsRepository().categories().then((cats) {
      if (mounted) {
        setState(() => _apiCategories = cats);
      }
    }).catchError((_) {});
    final listings = context.read<ListingsCubit>().state.listings;
    listing = listings.firstWhere(
      (l) => l.id == widget.listingId,
      orElse: () => listings.first,
    );

    _nameCtrl = TextEditingController(text: listing.title);
    _descCtrl = TextEditingController(text: listing.description ?? '');
    _tags = List<String>.from(listing.tags);

    // Product fields
    _priceCtrl = TextEditingController(
      text: listing.basePrice != null ? '${listing.basePrice!.toInt()}' : '',
    );
    _perDayCtrl = TextEditingController(
      text: listing.perDayRate != null ? '${listing.perDayRate!.toInt()}' : '',
    );
    _depositCtrl = TextEditingController(
      text: listing.depositAmount != null
          ? '${listing.depositAmount!.toInt()}'
          : '',
    );
    _durationCtrl = TextEditingController();
    _skuCtrl = TextEditingController(text: listing.sku ?? '');
    _quantityCtrl = TextEditingController(
      text: listing.stockQuantity != null ? '${listing.stockQuantity}' : '',
    );
    _isForRent = listing.isRentable;

    // Service fields
    _minPriceCtrl = TextEditingController(
      text: listing.basePrice != null ? '${listing.basePrice!.toInt()}' : '',
    );
    _maxPriceCtrl = TextEditingController();
    _durationDaysCtrl = TextEditingController();
    _durationHoursCtrl = TextEditingController();
    _durationMinsCtrl = TextEditingController();
    // Prefill the service-duration box matching the stored unit.
    if (listing.durationValue != null) {
      final v = '${listing.durationValue}';
      switch (listing.durationUnit) {
        case 'Days':
          _durationDaysCtrl.text = v;
          break;
        case 'Mins':
          _durationMinsCtrl.text = v;
          break;
        case 'Hours':
        default:
          _durationHoursCtrl.text = v;
      }
    }
    if (listing.cancellationPolicy != null &&
        listing.cancellationPolicy!.isNotEmpty) {
      _selectedCancellationPolicy = listing.cancellationPolicy!;
    }
    _selectedCategory = listing.categoryName;

    if (listing.basePrice != null) {
      _priceRange = RangeValues(
        listing.basePrice!,
        (listing.basePrice! * 2).clamp(0, 1000000),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _perDayCtrl.dispose();
    _depositCtrl.dispose();
    _durationCtrl.dispose();
    _skuCtrl.dispose();
    _quantityCtrl.dispose();
    _minPriceCtrl.dispose();
    _maxPriceCtrl.dispose();
    _durationDaysCtrl.dispose();
    _durationHoursCtrl.dispose();
    _durationMinsCtrl.dispose();
    super.dispose();
  }

  // ─── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    final label = _isService ? 'Service' : 'Product';
    final subtitle = _isService
        ? 'Update this service for your business'
        : 'Update your product and increase your stock count';

    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Container(
        decoration: _gradientDecoration,
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
                  'Update $label',
                  style: GoogleFonts.urbanist(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
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
    );
  }

  // ─── Shared helpers ────────────────────────────────────────────────────────

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

  Widget _buildDropdownSelector({
    required String label,
    required String? value,
    required String placeholder,
    required VoidCallback onTap,
    Widget? labelSuffix,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.c.textSecondary,
                ),
              ),
              if (labelSuffix != null) ...[
                const SizedBox(width: 4),
                labelSuffix,
              ],
            ],
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
                    value ?? placeholder,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: value != null
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

  Widget _buildPhotoSlot({
    required String label,
    required String? imageUrl,
    required VoidCallback onDelete,
  }) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppNetworkImage(
              url: imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo upload coming soon')),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.c.divider,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.c.border,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon('gallery', size: 24, color: context.c.textHint),
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

  Widget _buildPhotosGrid(List<String> photoLabels) {
    final urls = listing.mediaUrls;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: photoLabels.length,
      itemBuilder: (_, i) => _buildPhotoSlot(
        label: photoLabels[i],
        imageUrl: i < urls.length ? urls[i] : null,
        onDelete: () {},
      ),
    );
  }

  // ─── Bottom sheet helpers ──────────────────────────────────────────────────

  void _showSimpleBottomSheet({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String> onSelect,
  }) {
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
                    title,
                    style: GoogleFonts.urbanist(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Flexible(
                  child: options.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(28),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : ListView(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 12),
                          children: options
                              .map(
                                (opt) => ListTile(
                                  title: Text(
                                    opt,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 15,
                                      color: context.c.textPrimary,
                                    ),
                                  ),
                                  trailing: selected == opt
                                      ? const Icon(Icons.check_rounded,
                                          color: AppColors.primary)
                                      : null,
                                  onTap: () {
                                    onSelect(opt);
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

  void _showSizesBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Sizes',
                    style: GoogleFonts.urbanist(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _sizes.map((size) {
                      final isSelected = _selectedSizes.contains(size);
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            if (isSelected) {
                              _selectedSizes.remove(size);
                            } else {
                              _selectedSizes.add(size);
                            }
                          });
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 56,
                          height: 44,
                          decoration: BoxDecoration(
                            color:
                                isSelected ? AppColors.primary : context.c.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : context.c.border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              size,
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : context.c.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  AppButton.primary(
                    'Done',
                    onTap: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─── Product form ──────────────────────────────────────────────────────────

  Widget _buildProductTypeDropdown() {
    final typeLabel = _isForRent ? 'For rent' : 'For sale';
    return _buildDropdownSelector(
      label: 'Product type 📦',
      value: typeLabel,
      placeholder: 'Select type',
      onTap: () {
        _showSimpleBottomSheet(
          title: 'Product Type',
          options: ['For sale', 'For rent'],
          selected: typeLabel,
          onSelect: (val) {
            setState(() => _isForRent = val == 'For rent');
          },
        );
      },
    );
  }

  Widget _buildSizesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Sizes ',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.c.textSecondary,
              ),
            ),
            Text(
              '(optional)',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _showSizesBottomSheet,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 52),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: context.c.surfaceElevated,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _selectedSizes.isEmpty
                      ? Text(
                          'Select sizes',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            color: context.c.textHint,
                          ),
                        )
                      : Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _selectedSizes.map((size) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: context.c.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    size,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      setState(
                                          () => _selectedSizes.remove(size));
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 13,
                                      color: AppColors.primary
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.c.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInput(
          label: 'Product Name',
          hint: 'Enter product name...',
          controller: _nameCtrl,
        ),
        const SizedBox(height: 16),
        _buildProductTypeDropdown(),
        const SizedBox(height: 16),
        AppInput(
          label: 'Product Description',
          hint: 'Describe your product...',
          controller: _descCtrl,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
        ),
        const SizedBox(height: 16),
        _buildDropdownSelector(
          label: 'Category',
          value: _selectedCategory,
          placeholder: 'Select a category',
          onTap: () {
            _showSimpleBottomSheet(
              title: 'Select Category',
              options: _apiCategoryNames,
              selected: _selectedCategory,
              onSelect: (cat) => setState(() => _selectedCategory = cat),
            );
          },
        ),
        const SizedBox(height: 16),

        // Conditional price fields
        if (!_isForRent) ...[
          AppInput(
            label: 'Product Price',
            hint: '0',
            controller: _priceCtrl,
            keyboardType: TextInputType.number,
            prefixIcon: const _NairaPrefix(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ] else ...[
          AppInput(
            label: 'Price per day',
            hint: '0',
            controller: _perDayCtrl,
            keyboardType: TextInputType.number,
            prefixIcon: const _NairaPrefix(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
          AppInput(
            label: 'Refundable Deposit',
            hint: '0',
            controller: _depositCtrl,
            keyboardType: TextInputType.number,
            prefixIcon: const _NairaPrefix(),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 16),
          // Rental Duration row
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rental Duration',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.c.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _durationCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: context.c.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: GoogleFonts.urbanist(
                          fontSize: 15,
                          color: context.c.textHint,
                        ),
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: context.c.textSecondary,
                        ),
                        filled: true,
                        fillColor: context.c.surfaceElevated,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: context.c.primaryLight,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Days',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],

        const SizedBox(height: 16),
        AppInput(
          label: 'SKU',
          hint: 'Enter SKU...',
          controller: _skuCtrl,
        ),
        const SizedBox(height: 16),
        AppInput(
          label: 'Quantity in Stock',
          hint: '0',
          controller: _quantityCtrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 16),
        _buildSizesSelector(),
        const SizedBox(height: 16),
        TagInputField(
          tags: _tags,
          label: 'Tags',
          hint: 'e.g. Wedding, Cake, Luxury',
          onChanged: (updated) => setState(() => _tags = updated),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('Product Photos'),
        _buildPhotosGrid([
          'Main Photo',
          'Second Photo',
          'Third Photo',
          'Fourth Photo',
        ]),
        const SizedBox(height: 8),
      ],
    );
  }

  // ─── Service form ──────────────────────────────────────────────────────────

  Widget _buildPriceRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: context.c.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: context.c.primaryLight,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.12),
            rangeThumbShape:
                const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
            trackHeight: 4,
          ),
          child: RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000000,
            divisions: 100,
            activeColor: AppColors.primary,
            onChanged: (values) => setState(() => _priceRange = values),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildPriceDisplay('Min', _priceRange.start.round())),
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
            color: context.c.textHint,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: context.c.surfaceElevated,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.c.primaryLight,
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
                    color: context.c.textPrimary,
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

  Widget _buildDurationBox({
    required String label,
    required TextEditingController controller,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: context.c.textHint,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: context.c.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: GoogleFonts.urbanist(
                fontSize: 14,
                color: context.c.textHint,
              ),
              prefixIcon: Icon(
                Icons.access_time_rounded,
                size: 18,
                color: context.c.textSecondary,
              ),
              filled: true,
              fillColor: context.c.surfaceElevated,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDuration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Duration',
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: context.c.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildDurationBox(label: 'Days', controller: _durationDaysCtrl),
            const SizedBox(width: 10),
            _buildDurationBox(label: 'Hours', controller: _durationHoursCtrl),
            const SizedBox(width: 10),
            _buildDurationBox(label: 'Mins', controller: _durationMinsCtrl),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppInput(
          label: 'Service Name',
          hint: 'Enter service name...',
          controller: _nameCtrl,
        ),
        const SizedBox(height: 16),
        AppInput(
          label: 'Service Description',
          hint: 'Describe your service...',
          controller: _descCtrl,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
        ),
        const SizedBox(height: 16),
        _buildDropdownSelector(
          label: 'Category',
          value: _selectedCategory,
          placeholder: 'Select a category',
          onTap: () {
            _showSimpleBottomSheet(
              title: 'Select Category',
              options: _apiCategoryNames,
              selected: _selectedCategory,
              onSelect: (cat) => setState(() => _selectedCategory = cat),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildPriceRange(),
        const SizedBox(height: 16),
        _buildServiceDuration(),
        const SizedBox(height: 16),
        _buildDropdownSelector(
          label: 'Cancellation Policy',
          value: _selectedCancellationPolicy.isEmpty
              ? null
              : _selectedCancellationPolicy,
          placeholder: 'Select a policy',
          onTap: () {
            _showSimpleBottomSheet(
              title: 'Cancellation Policy',
              options: _cancellationPolicies,
              selected: _selectedCancellationPolicy,
              onSelect: (p) =>
                  setState(() => _selectedCancellationPolicy = p),
            );
          },
        ),
        const SizedBox(height: 16),
        TagInputField(
          tags: _tags,
          label: 'Tags',
          hint: 'e.g. Wedding, Photography, Outdoor',
          onChanged: (updated) => setState(() => _tags = updated),
        ),
        const SizedBox(height: 20),
        _buildSectionTitle('Service Photos'),
        _buildPhotosGrid([
          'Main Photo',
          'Second Photo',
          'Third Photo',
          'Fourth Photo',
        ]),
        const SizedBox(height: 8),
      ],
    );
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final label = _isService ? 'Service' : 'Product';
    return Scaffold(
      backgroundColor: context.c.surface,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: pagePadding(context, base: 20)
                  .add(const EdgeInsets.symmetric(vertical: 20)),
              child: _isService ? _buildServiceForm() : _buildProductForm(),
            ),
          ),
          Container(
            padding: pagePadding(context, base: 20)
                .add(const EdgeInsets.only(top: 12, bottom: 28)),
            decoration: BoxDecoration(
              color: context.c.surface,
              border: Border(top: BorderSide(color: context.c.border)),
            ),
            child: AppButton.primary(
              'Update $label',
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);
                final router = GoRouter.of(context);
                final cubit = context.read<ListingsCubit>();
                final changes = <String, dynamic>{
                  'title': _nameCtrl.text.trim(),
                  'description': _descCtrl.text.trim(),
                  'tags': _tags,
                };
                final priceText = _priceCtrl.text.trim().isNotEmpty
                    ? _priceCtrl.text
                    : _minPriceCtrl.text;
                final price =
                    num.tryParse(priceText.replaceAll(',', '').trim());
                if (price != null) changes['basePrice'] = price;

                // Resolve category name → id (only if it maps to a known one).
                if (_selectedCategory != null) {
                  final match = _apiCategories
                      .where((c) => c.name == _selectedCategory)
                      .toList();
                  if (match.isNotEmpty) changes['categoryId'] = match.first.id;
                }

                if (_isService) {
                  // Send the single filled duration box as value + unit.
                  final durByUnit = <String, int?>{
                    'Days': int.tryParse(_durationDaysCtrl.text.trim()),
                    'Hours': int.tryParse(_durationHoursCtrl.text.trim()),
                    'Mins': int.tryParse(_durationMinsCtrl.text.trim()),
                  };
                  final filled = _durationUnits.firstWhere(
                    (u) => (durByUnit[u] ?? 0) > 0,
                    orElse: () => '',
                  );
                  if (filled.isNotEmpty) {
                    changes['durationValue'] = durByUnit[filled];
                    changes['durationUnit'] = filled;
                  }
                  changes['cancellationPolicy'] = _selectedCancellationPolicy;
                } else {
                  final sku = _skuCtrl.text.trim();
                  changes['sku'] = sku.isEmpty ? null : sku;
                  changes['stockQuantity'] =
                      int.tryParse(_quantityCtrl.text.trim());
                }
                try {
                  await ListingsRepository().update(listing.id, changes);
                  if (!mounted) return;
                  cubit.load();
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('Listing updated successfully'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  router.pop();
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(
                      content:
                          Text(e.toString().replaceFirst('Exception: ', '')),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Naira prefix icon ─────────────────────────────────────────────────────────

class _NairaPrefix extends StatelessWidget {
  const _NairaPrefix();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 18,
            color: context.c.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            '₦',
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: context.c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
