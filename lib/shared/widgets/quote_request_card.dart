import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../widgets/app_button.dart';

/// A reusable card widget that displays a single quote/request with optional
/// action buttons. Used on both the Home dashboard and the Orders screen.
class QuoteRequestCard extends StatelessWidget {
  final dynamic quote;
  final VoidCallback onRespond;
  final VoidCallback? onReject;

  /// When [showSingleButton] is true only "Open & Respond" is shown (home use).
  /// When false, both "Reject" and "Open & Respond" are shown (orders use).
  final bool showSingleButton;

  const QuoteRequestCard({
    super.key,
    required this.quote,
    required this.onRespond,
    this.onReject,
    this.showSingleButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final clientImage = quote.clientImage as String?;
    final clientName = quote.clientName as String;
    final eventName = quote.eventName as String;
    final createdAt = quote.createdAt as DateTime;
    final totalAmount = quote.totalAmount as double;
    final notes = quote.notes as String?;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.divider,
                  backgroundImage: (clientImage != null && clientImage.isNotEmpty)
                      ? NetworkImage(clientImage)
                      : null,
                  child: (clientImage == null || clientImage.isEmpty)
                      ? Text(
                          clientName.isNotEmpty ? clientName[0] : '?',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clientName,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$eventName · ${Formatters.timeAgo(createdAt)}',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'New',
                    style: GoogleFonts.urbanist(
                      color: const Color(0xFF16A34A),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (notes != null && notes.isNotEmpty)
              Text(
                notes,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              totalAmount > 0
                  ? 'Budget: ${Formatters.formatCurrency(totalAmount)}'
                  : 'Budget: TBD',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 14),
            if (showSingleButton)
              Row(
                children: [
                  Expanded(
                    child: AppButton.secondary(
                      'Open & Respond',
                      onTap: onRespond,
                      size: ButtonSize.sm,
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: AppButton.secondary(
                      'Reject',
                      onTap: onReject ?? () {},
                      size: ButtonSize.sm,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton.primary(
                      'Open & Respond',
                      onTap: onRespond,
                      size: ButtonSize.sm,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
