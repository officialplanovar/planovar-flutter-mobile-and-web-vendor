import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _tagsController = TextEditingController();
  final _durationValueController = TextEditingController(text: '1');

  String? _selectedCategory;
  String _selectedCancellationPolicy = '';
  String _durationUnit = 'Hours';
  RangeValues _priceRange = const RangeValues(0, 500000);

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

  final List<String> _cancellationPolicies = ['Flexible', 'Moderate', 'Strict'];
  final List<String> _durationUnits = ['Days', 'Hours', 'Mins'];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _tagsController.dispose();
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
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
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
                      ? const Icon(Icons.check_rounded, color: AppColors.primary)
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
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      color: isSelected ? Colors.white : AppColors.textSecondary,
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
          color: AppColors.primaryLight.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Column(
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
              'Add a Service',
              style: GoogleFonts.urbanist(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Add a service for your business',
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
                      _buildPhotoBox('Photo 1'),
                      _buildPhotoBox('Photo 2'),
                      _buildPhotoBox('Photo 3'),
                      _buildPhotoBox('Photo 4'),
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
              'Publish Service',
              onTap: () {
                context.pushReplacement(
                  '/listings/add-success',
                  extra: {
                    'isService': true,
                    'productId': '#SV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                    'sku': 'SVC${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
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
