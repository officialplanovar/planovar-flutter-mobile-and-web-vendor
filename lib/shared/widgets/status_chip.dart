import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusChip({super.key, required this.status, this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor, label) = _statusProps(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
      ),
    );
  }

  (Color, Color, String) _statusProps(BuildContext context, String status) {
    final t = AppLocalizations.of(context);
    switch (status.toUpperCase()) {
      case 'PENDING':
        return (AppColors.warning, const Color(0xFFFFF8E1), t.statusPending);
      case 'CONFIRMED':
        return (AppColors.success, const Color(0xFFE8F5E9), t.statusConfirmed);
      case 'ACTIVE':
        return (AppColors.primary, AppColors.primaryLight, t.statusActive);
      case 'COMPLETED':
        return (const Color(0xFF1565C0), const Color(0xFFE3F2FD), t.statusCompleted);
      case 'CANCELLED':
        return (AppColors.error, const Color(0xFFFFEBEE), t.statusCancelled);
      case 'SENT':
        return (AppColors.primary, AppColors.primaryLight, t.statusSent);
      case 'ACCEPTED':
        return (AppColors.success, const Color(0xFFE8F5E9), t.statusAccepted);
      case 'REJECTED':
        return (AppColors.error, const Color(0xFFFFEBEE), t.statusRejected);
      case 'PAID':
        return (AppColors.success, const Color(0xFFE8F5E9), t.statusPaid);
      case 'FAILED':
        return (AppColors.error, const Color(0xFFFFEBEE), t.statusFailed);
      case 'FEATURED':
        return (AppColors.warning, const Color(0xFFFFF8E1), t.statusFeatured);
      case 'PREMIUM':
        return (AppColors.primary, AppColors.primaryLight, t.statusPremium);
      case 'BASIC':
        return (AppColors.textSecondary, AppColors.divider, t.statusBasic);
      default:
        return (AppColors.textSecondary, AppColors.divider, status);
    }
  }
}
