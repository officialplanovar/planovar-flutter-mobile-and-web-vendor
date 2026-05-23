import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/mock/mock_data.dart';
import '../../../shared/models/quote_model.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../../../shared/widgets/status_chip.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    // First try to find in pendingQuotes
    final QuoteModel? quote = MockData.pendingQuotes
        .where((q) => q.id == orderId)
        .cast<QuoteModel?>()
        .firstOrNull;

    if (quote != null) {
      return _QuoteDetailScreen(quote: quote);
    }

    // Fall back to bookings
    final BookingModel? booking = MockData.bookings
        .where((b) => b.id == orderId)
        .cast<BookingModel?>()
        .firstOrNull;

    if (booking != null) {
      return _BookingDetailScreen(booking: booking);
    }

    // Not found
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Order Not Found',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'No order found for ID: $orderId',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Quote Detail Screen ──────────────────────────────────────────────────────

class _QuoteDetailScreen extends StatefulWidget {
  final QuoteModel quote;

  const _QuoteDetailScreen({required this.quote});

  @override
  State<_QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends State<_QuoteDetailScreen> {
  late TextEditingController _priceController;
  late TextEditingController _notesController;
  String _selectedPaymentTerm = 'Full Payment';

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.quote.totalAmount > 0
          ? Formatters.formatCurrency(widget.quote.totalAmount)
          : '',
    );
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quote = widget.quote;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Quote Request',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Client Card ────────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.divider,
                        backgroundImage: (quote.clientImage != null &&
                                quote.clientImage!.isNotEmpty)
                            ? NetworkImage(quote.clientImage!)
                            : null,
                        child: (quote.clientImage == null ||
                                quote.clientImage!.isEmpty)
                            ? Text(
                                quote.clientName.isNotEmpty
                                    ? quote.clientName[0]
                                    : '?',
                                style: GoogleFonts.urbanist(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondary,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              quote.clientName,
                              style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Client · ${Formatters.timeAgo(quote.createdAt)}',
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'New Request',
                          style: GoogleFonts.urbanist(
                            color: const Color(0xFF16A34A),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 16),
                  _DetailRow(
                    icon: Icons.celebration_outlined,
                    label: 'Event',
                    value: quote.eventName,
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Date',
                    value: Formatters.formatDate(quote.eventDate),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Request Details Card ───────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request Details',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (quote.notes != null && quote.notes!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        quote.notes!,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (quote.lineItems.isNotEmpty) ...[
                    ...quote.lineItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.label,
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            Text(
                              Formatters.formatCurrency(item.amount),
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 20, color: AppColors.divider),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        quote.totalAmount > 0
                            ? Formatters.formatCurrency(quote.totalAmount)
                            : 'TBD',
                        style: GoogleFonts.urbanist(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Respond Section ────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Quote',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppInput(
                    label: 'Your Price',
                    hint: 'e.g. ₦150,000',
                    controller: _priceController,
                    prefixIcon: const Icon(
                      Icons.payments_outlined,
                      color: AppColors.textHint,
                      size: 20,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  AppTextArea(
                    label: 'Notes to Client',
                    hint:
                        'Add any details, inclusions, or conditions for this quote...',
                    controller: _notesController,
                    minLines: 3,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Payment Terms',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: ['Full Payment', 'Installments'].map((term) {
                      final selected = _selectedPaymentTerm == term;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedPaymentTerm = term),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            term,
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Action Buttons ─────────────────────────────────────────────
            AppButton.primary(
              'Send Quote',
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 12),
            AppButton.ghost(
              'Decline Request',
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Booking Detail Screen ────────────────────────────────────────────────────

class _BookingDetailScreen extends StatelessWidget {
  final BookingModel booking;

  const _BookingDetailScreen({required this.booking});

  @override
  Widget build(BuildContext context) {
    final shortId = booking.id.length >= 8
        ? booking.id.substring(0, 8).toUpperCase()
        : booking.id.toUpperCase();

    final timelineSteps = [
      ('Booked', Icons.bookmark_added_outlined, true),
      ('Confirmed', Icons.check_circle_outline_rounded, booking.status != 'PENDING'),
      (
        'In Progress',
        Icons.autorenew_rounded,
        booking.status == 'ACTIVE' || booking.status == 'COMPLETED',
      ),
      ('Completed', Icons.verified_outlined, booking.status == 'COMPLETED'),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Order #$shortId',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: StatusChip(status: booking.status, fontSize: 12),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Client Info Card ───────────────────────────────────────────
            _SectionCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.divider,
                    backgroundImage: (booking.clientImage != null &&
                            booking.clientImage!.isNotEmpty)
                        ? NetworkImage(booking.clientImage!)
                        : null,
                    child: (booking.clientImage == null ||
                            booking.clientImage!.isEmpty)
                        ? Text(
                            booking.clientName.isNotEmpty
                                ? booking.clientName[0]
                                : '?',
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.clientName,
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Client · Booked ${Formatters.timeAgo(booking.createdAt)}',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Order Details Card ─────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Details',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _DetailRow(
                    icon: Icons.layers_outlined,
                    label: 'Listing',
                    value: booking.listingTitle,
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.celebration_outlined,
                    label: 'Event',
                    value: booking.eventName,
                  ),
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Event Date',
                    value: Formatters.formatDate(booking.eventDate),
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        Formatters.formatCurrency(booking.totalAmount),
                        style: GoogleFonts.urbanist(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Escrow/Payment Status Card ─────────────────────────────────
            if (booking.escrowType != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      AppColors.primary.withValues(alpha: 0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.18)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Secured in Escrow',
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking.escrowType == 'split'
                                ? 'Client has paid 50% deposit. Remaining balance held until completion.'
                                : 'Full payment held securely until the order is completed.',
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Timeline Card ──────────────────────────────────────────────
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Timeline',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...timelineSteps.asMap().entries.map((entry) {
                    final i = entry.key;
                    final (label, icon, active) = entry.value;
                    final isLast = i == timelineSteps.length - 1;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.primary
                                    : AppColors.divider,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon,
                                size: 16,
                                color: active
                                    ? Colors.white
                                    : AppColors.textHint,
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 32,
                                color: active
                                    ? AppColors.primary.withValues(alpha: 0.3)
                                    : AppColors.divider,
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            label,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight:
                                  active ? FontWeight.w600 : FontWeight.w400,
                              color: active
                                  ? AppColors.textPrimary
                                  : AppColors.textHint,
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: GoogleFonts.urbanist(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
