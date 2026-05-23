import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/mock/mock_data.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/network_image_widget.dart';

class EditListingScreen extends StatefulWidget {
  final String listingId;

  const EditListingScreen({super.key, required this.listingId});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  late ListingModel listing;
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _perDayController;
  late TextEditingController _depositController;
  late TextEditingController _skuController;
  late TextEditingController _tagsController;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;

  String _selectedCancellationPolicy = 'Flexible';
  String _durationUnit = 'Hours';
  int _durationValue = 1;
  String? _selectedCategory;
  final Set<String> _selectedSizes = {};
  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  final List<String> _categories = [
    'Cakes & Desserts',
    'Photography',
    'Catering',
    'Decor',
    'DJ & Music',
    'Venues',
    'Beauty',
    'Confectionery',
    'Planning',
  ];

  bool get _isService =>
      listing.pricingType == 'QUOTE' || listing.pricingType == 'HOURLY';

  @override
  void initState() {
    super.initState();
    listing = MockData.listings.firstWhere(
      (l) => l.id == widget.listingId,
      orElse: () => MockData.listings.first,
    );
    _nameController = TextEditingController(text: listing.title);
    _descController = TextEditingController(text: listing.description ?? '');
    _priceController = TextEditingController(
      text: listing.basePrice != null ? '${listing.basePrice!.toInt()}' : '',
    );
    _perDayController = TextEditingController(
      text: listing.perDayRate != null ? '${listing.perDayRate!.toInt()}' : '',
    );
    _depositController = TextEditingController(
      text: listing.depositAmount != null
          ? '${listing.depositAmount!.toInt()}'
          : '',
    );
    _skuController = TextEditingController();
    _tagsController =
        TextEditingController(text: listing.tags.join(', '));
    _minPriceController = TextEditingController(
      text: listing.basePrice != null ? '${listing.basePrice!.toInt()}' : '',
    );
    _maxPriceController = TextEditingController();
    _selectedCategory = listing.categoryName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _perDayController.dispose();
    _depositController.dispose();
    _skuController.dispose();
    _tagsController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _showDeleteDialog() {
    final label = _isService ? 'Service' : 'Product';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.cancelledBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Delete $label',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to permanently delete this $label? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    'No, Keep',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(double.infinity, 52),
                      elevation: 0,
                    ),
                    child: Text(
                      'Yes, Delete',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeactivateDialog() {
    final label = _isService ? 'Service' : 'Product';
    final isActive = listing.isActive;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7ED),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pause_circle_outline_rounded,
                color: Color(0xFFEA580C),
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isActive ? 'Deactivate $label' : 'Activate $label',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isActive
                  ? 'This will hide your $label from clients and stop new bookings.'
                  : 'This will make your $label visible to clients again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFED7AA)),
                ),
                child: Text(
                  'You currently have active Contacts tied to this service. Enquire or your service will auto-cancel after event date.',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: const Color(0xFFEA580C),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    'No, Continue',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEA580C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(double.infinity, 52),
                      elevation: 0,
                    ),
                    child: Text(
                      isActive ? 'Yes, Deactivate' : 'Yes, Activate',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  Widget _buildCoverImage() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 180,
          child: AppNetworkImage(
            url: listing.displayCoverUrl ?? '',
            width: double.infinity,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Photo update coming soon')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.edit_outlined,
                      color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Edit Photo',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildStatItem(
              'Views', '${listing.viewCount}', Icons.visibility_outlined),
          _buildStatDivider(),
          _buildStatItem(
              'Reviews', '${listing.reviewCount}', Icons.star_border_rounded),
          _buildStatDivider(),
          _buildStatItem(
              'Rating',
              listing.ratingAvg.toStringAsFixed(1),
              Icons.thumb_up_alt_outlined),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 36, color: AppColors.border);
  }

  Widget _buildServiceForm() {
    return Column(
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
        AppInput(
          label: 'Tags',
          hint: 'Enter tags...',
          controller: _tagsController,
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
        AppInput(
          label: 'Product Price',
          hint: '0',
          controller: _priceController,
          keyboardType: TextInputType.number,
          prefixText: '₦',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        if (listing.isRentable) ...[
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
        ],
        const SizedBox(height: 16),
        AppInput(
          label: 'SKU',
          hint: 'Enter product SKU...',
          controller: _skuController,
        ),
        const SizedBox(height: 16),
        _buildSectionTitle('Available Sizes (Optional)'),
        _buildSizesRow(),
        const SizedBox(height: 16),
        AppInput(
          label: 'Tags',
          hint: 'Enter tags...',
          controller: _tagsController,
        ),
      ],
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
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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

  void _showCategoryBottomSheet() {
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
                  'Select Category',
                  style: GoogleFonts.urbanist(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const Divider(height: 1),
              ..._categories.map(
                (cat) => ListTile(
                  title: Text(
                    cat,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing: _selectedCategory == cat
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedCategory = cat);
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
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: AppInput(
                hint: '0,000',
                controller: _minPriceController,
                keyboardType: TextInputType.number,
                prefixText: '₦',
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'to',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: AppInput(
                hint: '0,000',
                controller: _maxPriceController,
                keyboardType: TextInputType.number,
                prefixText: '₦',
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
      ],
    );
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
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_durationValue > 1) {
                          setState(() => _durationValue--);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: const Icon(Icons.remove_rounded,
                            size: 18, color: AppColors.textSecondary),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '$_durationValue',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _durationValue++),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: const Icon(Icons.add_rounded,
                            size: 18, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButton<String>(
                  value: _durationUnit,
                  onChanged: (val) {
                    if (val != null) setState(() => _durationUnit = val);
                  },
                  items: ['Mins', 'Hours', 'Days']
                      .map(
                        (u) => DropdownMenuItem(
                          value: u,
                          child: Text(
                            u,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  underline: const SizedBox.shrink(),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondary),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCancellationPolicy() {
    final policies = ['Flexible', 'Moderate', 'Strict'];
    return Column(
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
        const SizedBox(height: 8),
        Row(
          children: policies.map((policy) {
            final isSelected = _selectedCancellationPolicy == policy;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() => _selectedCancellationPolicy = policy);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    policy,
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
      ],
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
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:
                    isSelected ? AppColors.primary : AppColors.border,
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
                      : AppColors.textSecondary,
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
    final label = _isService ? 'Service' : 'Product';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.divider,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'Update $label',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCoverImage(),
                  _buildStatsBar(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    child: _isService
                        ? _buildServiceForm()
                        : _buildProductForm(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Column(
              children: [
                AppButton.primary(
                  'Edit $label',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('$label updated successfully!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _showDeactivateDialog,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(14),
                            border: Border.all(
                                color: const Color(0xFFEA580C)),
                          ),
                          child: Center(
                            child: Text(
                              listing.isActive
                                  ? 'Deactivate $label'
                                  : 'Activate $label',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFEA580C),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showDeleteDialog,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.cancelledBg,
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              'Delete $label',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
