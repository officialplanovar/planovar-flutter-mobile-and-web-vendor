import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/app_button.dart';

class AddListingTypeScreen extends StatefulWidget {
  const AddListingTypeScreen({super.key});

  @override
  State<AddListingTypeScreen> createState() => _AddListingTypeScreenState();
}

class _AddListingTypeScreenState extends State<AddListingTypeScreen> {
  String? _selectedType;

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
            decoration: BoxDecoration(
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
          'New Listing',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Listing Type',
                style: GoogleFonts.urbanist(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select the type of listing you want to create',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              _buildTypeCard(
                type: 'service',
                icon: Icons.design_services_rounded,
                title: 'Service',
                subtitle: 'Bookable appointment',
              ),
              const SizedBox(height: 16),
              _buildTypeCard(
                type: 'product',
                icon: Icons.inventory_2_rounded,
                title: 'Product',
                subtitle: 'Physical item for rent or sale',
              ),
              const Spacer(),
              AppButton.primary(
                'Proceed',
                onTap: _selectedType == null
                    ? null
                    : () {
                        if (_selectedType == 'service') {
                          context.push(AppRoutes.addService);
                        } else {
                          context.push(AppRoutes.addProduct);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard({
    required String type,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primary : AppColors.textHint,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
