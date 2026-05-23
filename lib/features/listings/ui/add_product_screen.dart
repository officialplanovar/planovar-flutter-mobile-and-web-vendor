import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';

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
  final _skuController = TextEditingController();
  final _quantityController = TextEditingController();
  final _tagsController = TextEditingController();

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
    _tagsController.dispose();
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

  Widget _buildToggleTabs() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.divider,
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
            color: isActive ? Colors.white : Colors.transparent,
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
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoBox(String label) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo upload coming soon')),
        );
      },
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_photo_alternate_outlined,
              color: AppColors.textHint,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 11,
                color: AppColors.textSecondary,
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
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Center(
              child: Text(
                size,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add a Product',
              style: GoogleFonts.urbanist(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Add a product to your catalogue',
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: AppColors.textSecondary,
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
                  const SizedBox(height: 16),
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
                  AppInput(
                    label: 'Tags',
                    hint: 'Enter tags...',
                    controller: _tagsController,
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
                      _buildPhotoBox('Front Photo'),
                      _buildPhotoBox('Back Photo'),
                      _buildPhotoBox('Side Photo'),
                      _buildPhotoBox('Detail Photo'),
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
              color: Colors.white,
              border: const Border(
                top: BorderSide(color: AppColors.border),
              ),
            ),
            child: AppButton.primary(
              'Publish Product',
              onTap: () {
                context.pushReplacement(
                  '/listings/add-success',
                  extra: {
                    'isService': false,
                    'productId': '#PN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                    'sku': 'SKU${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
