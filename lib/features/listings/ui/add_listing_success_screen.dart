import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../vendor/data/vendor_repository.dart';

class AddListingSuccessScreen extends StatefulWidget {
  final String productId;
  final String sku;
  final bool isService;

  const AddListingSuccessScreen({
    super.key,
    required this.productId,
    required this.sku,
    this.isService = false,
  });

  @override
  State<AddListingSuccessScreen> createState() =>
      _AddListingSuccessScreenState();
}

class _AddListingSuccessScreenState extends State<AddListingSuccessScreen> {
  bool? _verified; // null = still loading

  @override
  void initState() {
    super.initState();
    VendorRepository().getMe().then((v) {
      if (mounted && v != null) setState(() => _verified = v.isVerified);
    }).catchError((_) {});
  }

  String _formattedDate() {
    final now = DateTime.now();
    return DateFormat('MMM d, yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.isService ? 'Service' : 'Product';
    final pending = _verified == false;
    final subtitle = pending
        ? 'Your $label has been saved. It will become visible to clients once '
            'your account is verified.'
        : (widget.isService
            ? 'Your service has been added successfully and is currently Live'
            : 'Your product has been added successfully and is currently Live');

    return Scaffold(
      backgroundColor: context.c.background,
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
                                color: context.c.textPrimary,
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
                          color: context.c.textSecondary,
                          height: 1.5,
                        ),
                      ),

                      if (pending) ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFFDBA74)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.hourglass_bottom_rounded,
                                  size: 20, color: Color(0xFFEA580C)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Pending verification — clients can't see your "
                                  'listings until an admin verifies your account. '
                                  "We'll let you know once you're approved.",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 13,
                                    color: const Color(0xFF9A3412),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 36),

                      // Info card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.c.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: context.c.border),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              context,
                              label: '$label ID',
                              value: widget.productId,
                              isFirst: true,
                            ),
                            Divider(height: 1, color: context.c.border),
                            _buildInfoRow(
                              context,
                              label: 'SKU',
                              value: widget.sku,
                            ),
                            Divider(height: 1, color: context.c.border),
                            _buildInfoRow(
                              context,
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

  Widget _buildInfoRow(
    BuildContext context, {
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
              color: context.c.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: context.c.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
