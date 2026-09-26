import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/models/chat_card_models.dart';
import '../../../shared/models/conversation_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../data/quotes_repository.dart';

class CreateQuoteScreen extends StatefulWidget {
  final String conversationId;

  /// Legacy: send against an existing booking inquiry (old quote flow).
  final String? bookingId;

  /// New chat-order flow — when [clientId] + [listingId] are set, the quote is
  /// sent as a chat card via /chat-orders/quotes (direct-pay model).
  final String? clientId;
  final String? listingId;
  final String? eventId;

  /// When set, this replaces (revises) an existing active quote instead of
  /// sending a new one.
  final String? reviseQuoteId;

  /// The existing quote to prefill the form with (for revise).
  final ChatQuote? initialQuote;

  const CreateQuoteScreen({
    super.key,
    required this.conversationId,
    this.bookingId,
    this.clientId,
    this.listingId,
    this.eventId,
    this.reviseQuoteId,
    this.initialQuote,
  });

  @override
  State<CreateQuoteScreen> createState() => _CreateQuoteScreenState();
}

class _LineItem {
  final TextEditingController desc;
  final TextEditingController amount;

  _LineItem({String descText = '', String amountText = ''})
      : desc = TextEditingController(text: descText),
        amount = TextEditingController(text: amountText);

  void dispose() {
    desc.dispose();
    amount.dispose();
  }
}

class _CreateQuoteScreenState extends State<CreateQuoteScreen> {
  ConversationModel? _conv;
  late final List<_LineItem> _items;

  /// Optional free-text payment terms the vendor writes (paid off-platform).
  final TextEditingController _paymentTermsController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _validFor = '7 Days';
  bool _sending = false;

  int get _validDays {
    final match = RegExp(r'\d+').firstMatch(_validFor);
    return match != null ? int.parse(match.group(0)!) : 7;
  }

  /// Localized display label for an internal validity-window key.
  String _validForLabel(String opt) {
    final t = AppLocalizations.of(context);
    switch (opt) {
      case '1 Day':
        return t.cqValid1Day;
      case '3 Days':
        return t.cqValid3Days;
      case '7 Days':
        return t.cqValid7Days;
      case '14 Days':
        return t.cqValid14Days;
      case '30 Days':
        return t.cqValid30Days;
      default:
        return opt;
    }
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context);
    final paymentTermsText = _paymentTermsController.text.trim();
    final paymentTerms = paymentTermsText.isEmpty ? null : paymentTermsText;
    final lineItems = _items
        .map((i) => QuoteLineItemInput(
              label: i.desc.text.trim(),
              amount: double.tryParse(
                      i.amount.text.replaceAll(',', '').trim()) ??
                  0,
            ))
        .where((i) => i.label.isNotEmpty && i.amount > 0)
        .toList();
    if (lineItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.cqAddLineItem)),
      );
      return;
    }
    final note = _noteController.text.trim();

    // ── Revise an existing active quote ──
    if (widget.reviseQuoteId != null) {
      setState(() => _sending = true);
      try {
        await QuotesRepository().reviseQuote(
          quoteId: widget.reviseQuoteId!,
          lineItems: lineItems,
          paymentTerms: paymentTerms,
          validUntil: DateTime.now().add(Duration(days: _validDays)),
          notes: note.isEmpty ? null : note,
        );
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.cqRevisedSent)),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      } finally {
        if (mounted) setState(() => _sending = false);
      }
      return;
    }

    // ── New chat-order flow (client + listing context) ──
    if (widget.clientId != null && widget.listingId != null) {
      setState(() => _sending = true);
      try {
        await QuotesRepository().sendQuote(
          clientId: widget.clientId!,
          listingId: widget.listingId!,
          eventId: widget.eventId,
          lineItems: lineItems,
          paymentTerms: paymentTerms,
          validForDays: _validDays,
          notes: note.isEmpty ? null : note,
        );
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.cqQuoteSent)),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      } finally {
        if (mounted) setState(() => _sending = false);
      }
      return;
    }

    // ── Legacy booking-inquiry flow ──
    final bookingId = widget.bookingId;
    if (bookingId == null || bookingId.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.cqOpenFromChat)),
      );
      return;
    }

    setState(() => _sending = true);
    try {
      await QuotesRepository().create(
        bookingId: bookingId,
        lineItems: lineItems,
        validUntil: DateTime.now().add(Duration(days: _validDays)),
        notes: [
          if (paymentTermsText.isNotEmpty) 'Payment terms: $paymentTermsText',
          if (note.isNotEmpty) note,
        ].join('\n'),
      );
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quote sent to the client 🎉')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.conversationId.isNotEmpty) {
      MessagingService().getConversations().then((list) {
        if (!mounted) return;
        final match = list.where((c) => c.id == widget.conversationId);
        if (match.isNotEmpty) setState(() => _conv = match.first);
      }).catchError((_) {});
    }

    final q = widget.initialQuote;
    // Prefill line items from the existing quote (revise), else one empty row.
    _items = (q != null && q.lineItems.isNotEmpty)
        ? q.lineItems
            .map((li) => _LineItem(
                  descText: li.label,
                  amountText: li.amount.toInt().toString(),
                ))
            .toList()
        : [_LineItem(descText: '', amountText: '')];
    for (final item in _items) {
      item.amount.addListener(() => setState(() {}));
    }

    if (q != null) {
      _noteController.text = q.notes ?? '';
      _validFor = _closestValidFor(q.validUntil.difference(DateTime.now()).inDays);
      _paymentTermsController.text = q.paymentTerms ?? '';
    }
  }

  String _closestValidFor(int days) {
    const opts = {1: '1 Day', 3: '3 Days', 7: '7 Days', 14: '14 Days', 30: '30 Days'};
    if (days <= 0) return '7 Days';
    var best = 7;
    var bestDiff = 1 << 30;
    for (final k in opts.keys) {
      final d = (k - days).abs();
      if (d < bestDiff) {
        bestDiff = d;
        best = k;
      }
    }
    return opts[best]!;
  }

  @override
  void dispose() {
    for (final item in _items) {
      item.dispose();
    }
    _noteController.dispose();
    _paymentTermsController.dispose();
    super.dispose();
  }

  int get _subtotal {
    int total = 0;
    for (final item in _items) {
      total += int.tryParse(item.amount.text.replaceAll(',', '')) ?? 0;
    }
    return total;
  }

  void _addItem() {
    final newItem = _LineItem();
    newItem.amount.addListener(() => setState(() {}));
    setState(() => _items.add(newItem));
  }

  void _removeItem(int index) {
    final removed = _items.removeAt(index);
    removed.dispose();
    setState(() {});
  }

  Future<void> _showValidForSheet() async {
    final t = AppLocalizations.of(context);
    final options = ['1 Day', '3 Days', '7 Days', '14 Days', '30 Days'];
    await showModalBottomSheet(
      context: context,
      backgroundColor: context.c.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ctx.c.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            t.cqValidForTitle,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: ctx.c.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...options.map(
            (opt) => ListTile(
              title: Text(
                _validForLabel(opt),
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: _validFor == opt ? FontWeight.w700 : FontWeight.w500,
                  color: _validFor == opt ? AppColors.primary : ctx.c.textPrimary,
                ),
              ),
              trailing: _validFor == opt
                  ? const Icon(Icons.check_rounded, color: AppColors.primary)
                  : null,
              onTap: () {
                setState(() => _validFor = opt);
                Navigator.pop(ctx);
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  String _formattedEventDate() {
    if (_conv?.eventDate == null) return '';
    return Formatters.formatDate(_conv!.eventDate!);
  }

  Widget _buildGradientAppBar() {
    final t = AppLocalizations.of(context);
    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.reviseQuoteId != null ? t.convReviseQuote : t.cqTitleCreate,
                style: GoogleFonts.urbanist(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                '${_conv?.participantName ?? t.reviewClientFallback} · ${_conv?.eventName ?? t.cqEvent} · ${_formattedEventDate()}',
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: context.c.textPrimary,
      ),
    );
  }

  Widget _buildLineItemRow(int index) {
    final t = AppLocalizations.of(context);
    final item = _items[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: item.desc,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: context.c.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: t.cqDescription,
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: context.c.textHint,
                ),
                filled: true,
                fillColor: context.c.surfaceElevated,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: TextField(
              controller: item.amount,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: context.c.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: t.cqAmount,
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: context.c.textHint,
                ),
                filled: true,
                fillColor: context.c.surfaceElevated,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            color: AppColors.error,
            onPressed: () => _removeItem(index),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemButton() {
    return GestureDetector(
      onTap: _addItem,
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.primary.withValues(alpha: 0.5),
          radius: 24,
        ),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          child: Text(
            AppLocalizations.of(context).cqAddItem,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtotalRow() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        AppLocalizations.of(context).cqSubtotal(Formatters.formatCurrency(_subtotal)),
        style: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: context.c.textPrimary,
        ),
      ),
    );
  }

  Widget _buildPaymentTermsField() {
    final t = AppLocalizations.of(context);
    return TextField(
      controller: _paymentTermsController,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      style: GoogleFonts.urbanist(
        fontSize: 15,
        color: context.c.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: t.cqPaymentTermsHint,
        hintStyle: GoogleFonts.urbanist(
          fontSize: 15,
          color: context.c.textHint,
        ),
        filled: true,
        fillColor: context.c.surfaceElevated,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.c.background,
      appBar: _buildGradientAppBar() as PreferredSizeWidget,
      body: SingleChildScrollView(
        padding: pagePadding(context, base: 20)
            .add(const EdgeInsets.only(top: 24, bottom: 120)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Line Items
            _buildSectionTitle(t.cqLineItems),
            const SizedBox(height: 12),
            ...List.generate(_items.length, (i) => _buildLineItemRow(i)),
            const SizedBox(height: 8),
            _buildAddItemButton(),
            const SizedBox(height: 12),
            _buildSubtotalRow(),
            const SizedBox(height: 28),

            // Payment Terms (optional free text — paid directly, off-platform)
            _buildSectionTitle(t.cqSetPaymentTerms),
            const SizedBox(height: 12),
            _buildPaymentTermsField(),
            const SizedBox(height: 28),

            // Note to client
            _buildSectionTitle(t.cqNoteToClient),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: context.c.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: t.cqNoteHint,
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 15,
                  color: context.c.textHint,
                ),
                filled: true,
                fillColor: context.c.surfaceElevated,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Quote valid for
            _buildSectionTitle(t.cqValidForTitle),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _showValidForSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: context.c.surfaceElevated,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _validForLabel(_validFor),
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: context.c.textPrimary,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded,
                        color: context.c.textSecondary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: pagePadding(context, base: 20).add(EdgeInsets.only(
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        )),
        decoration: BoxDecoration(
          color: context.c.surface,
          border: Border(
            top: BorderSide(color: context.c.border),
          ),
        ),
        child: AppButton.primary(
          _sending
              ? t.cqSending
              : (widget.reviseQuoteId != null ? t.cqSendRevised : t.cqCreateQuote),
          loading: _sending,
          onTap: _sending ? null : _submit,
        ),
      ),
    );
  }
}

// Dashed border painter for "+ Add Item" button
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedBorderPainter({
    required this.color,
    this.radius = 24,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
