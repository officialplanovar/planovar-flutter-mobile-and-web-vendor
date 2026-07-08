import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

/// Visual variants matching the "Choose your plan" design.
enum PlanStyle { basic, popular, gold }

/// Styled subscription plan card, shared by onboarding and the upgrade screen.
/// Pass [isCurrent] on the upgrade screen to badge + disable the active plan,
/// and [loading] to spin the CTA while a switch is in flight.
class PlanCard extends StatelessWidget {
  final String name;
  final String amount; // "Free" | "$19.99" | "₦32,000"
  final String period; // "/ month" | "/ year"
  final List<String> features;
  final PlanStyle style;
  final String ctaLabel;
  final VoidCallback? onSelect; // null → disabled
  final bool isCurrent;
  final String currentBadgeLabel; // "Current" | "On trial"
  final bool loading;

  const PlanCard({
    super.key,
    required this.name,
    required this.amount,
    required this.period,
    required this.features,
    required this.style,
    required this.ctaLabel,
    required this.onSelect,
    this.isCurrent = false,
    this.currentBadgeLabel = 'Current',
    this.loading = false,
  });

  static const _navy = Color(0xFF161640);

  bool get _isPopular => style == PlanStyle.popular;

  @override
  Widget build(BuildContext context) {
    final onDark = _isPopular;
    final cardColor = _isPopular ? _navy : context.c.primaryLight;
    final nameColor = onDark ? Colors.white : context.c.textPrimary;
    final amountColor = onDark ? Colors.white : AppColors.primary;
    final featureColor = onDark ? Colors.white : context.c.textPrimary;
    final checkColor = onDark ? AppColors.success : context.c.textHint;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: _isPopular
            ? [
                BoxShadow(
                  color: _navy.withValues(alpha: 0.25),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.urbanist(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: nameColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: amount,
                            style: GoogleFonts.urbanist(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: amountColor,
                            ),
                          ),
                          TextSpan(
                            text: ' $period',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: onDark
                                  ? Colors.white70
                                  : context.c.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrent)
                _badge(currentBadgeLabel)
              else if (_isPopular)
                _badge('POPULAR'),
            ],
          ),
          const SizedBox(height: 18),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_rounded, color: checkColor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      f,
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: featureColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildCta(onDark),
        ],
      ),
    );
  }

  Widget _badge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCta(bool onDark) {
    // Current plan → muted, non-actionable.
    if (isCurrent) {
      return Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: onDark ? Colors.white.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: onDark ? null : Border.all(color: AppColors.border),
        ),
        alignment: Alignment.center,
        child: Text(
          'Current plan',
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: onDark ? Colors.white70 : AppColors.textSecondary,
          ),
        ),
      );
    }

    // Gold → solid primary pill; Basic & Premium → white pill with dark text.
    final solid = style == PlanStyle.gold;
    return GestureDetector(
      onTap: loading ? null : onSelect,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: solid ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: loading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: solid ? Colors.white : AppColors.primary,
                ),
              )
            : Text(
                ctaLabel,
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: solid ? Colors.white : AppColors.textPrimary,
                ),
              ),
      ),
    );
  }
}

/// Monthly / Yearly segmented toggle.
class BillingToggle extends StatelessWidget {
  final bool yearly;
  final ValueChanged<bool> onChanged;
  const BillingToggle({super.key, required this.yearly, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.c.border),
      ),
      child: Row(
        children: [
          Expanded(child: _segment('Monthly', !yearly, () => onChanged(false))),
          Expanded(child: _segment('Yearly', yearly, () => onChanged(true))),
        ],
      ),
    );
  }

  Widget _segment(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: active ? AppColors.primary : AppColors.textHint,
          ),
        ),
      ),
    );
  }
}
