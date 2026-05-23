import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

class AddListingSuccessScreen extends StatelessWidget {
  final String productId;
  final String sku;
  final bool isService;

  const AddListingSuccessScreen({
    super.key,
    required this.productId,
    required this.sku,
    this.isService = false,
  });

  String _formattedDate() {
    final now = DateTime.now();
    return DateFormat('MMM d, yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    final label = isService ? 'Service' : 'Product';
    final subtitle = isService
        ? 'Your service has been added successfully and is currently Live'
        : 'Your product has been added successfully and is currently Live';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 72),

                      // Green check circle
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3DBE6B),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3DBE6B).withValues(alpha: 0.30),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Title
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$label Added ',
                              style: GoogleFonts.urbanist(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextSpan(
                              text: 'Successfully',
                              style: GoogleFonts.urbanist(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Info card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              label: '$label ID',
                              value: productId,
                              isFirst: true,
                            ),
                            const Divider(height: 1, color: AppColors.border),
                            _buildInfoRow(
                              label: 'SKU',
                              value: sku,
                            ),
                            const Divider(height: 1, color: AppColors.border),
                            _buildInfoRow(
                              label: 'Date Created',
                              value: _formattedDate(),
                              isLast: true,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              child: AppButton.primary(
                'View $label',
                onTap: () => context.go('/listings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
