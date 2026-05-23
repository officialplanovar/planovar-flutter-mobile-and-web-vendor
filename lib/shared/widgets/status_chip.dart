import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class StatusChip extends StatelessWidget {
  final String status;
  final double fontSize;

  const StatusChip({super.key, required this.status, this.fontSize = 11});

  @override
  Widget build(BuildContext context) {
    final (color, bgColor, label) = _statusProps(status);
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

  (Color, Color, String) _statusProps(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return (AppColors.warning, const Color(0xFFFFF8E1), 'Pending');
      case 'CONFIRMED':
        return (AppColors.success, const Color(0xFFE8F5E9), 'Confirmed');
      case 'ACTIVE':
        return (AppColors.primary, AppColors.primaryLight, 'Active');
      case 'COMPLETED':
        return (const Color(0xFF1565C0), const Color(0xFFE3F2FD), 'Completed');
      case 'CANCELLED':
        return (AppColors.error, const Color(0xFFFFEBEE), 'Cancelled');
      case 'SENT':
        return (AppColors.primary, AppColors.primaryLight, 'Sent');
      case 'ACCEPTED':
        return (AppColors.success, const Color(0xFFE8F5E9), 'Accepted');
      case 'REJECTED':
        return (AppColors.error, const Color(0xFFFFEBEE), 'Rejected');
      case 'PAID':
        return (AppColors.success, const Color(0xFFE8F5E9), 'Paid');
      case 'FAILED':
        return (AppColors.error, const Color(0xFFFFEBEE), 'Failed');
      case 'FEATURED':
        return (AppColors.warning, const Color(0xFFFFF8E1), 'Featured');
      case 'PREMIUM':
        return (AppColors.primary, AppColors.primaryLight, 'Premium');
      case 'BASIC':
        return (AppColors.textSecondary, AppColors.divider, 'Basic');
      default:
        return (AppColors.textSecondary, AppColors.divider, status);
    }
  }
}
