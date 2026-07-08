import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/utils/formatters.dart';
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
  String _paymentTerm = 'Pay at once';
  final TextEditingController _noteController = TextEditingController();
  String _validFor = '7 Days';
  bool _sending = false;

  int get _validDays {
    final match = RegExp(r'\d+').firstMatch(_validFor);
    return match != null ? int.parse(match.group(0)!) : 7;
  }

  /// The payment terms selection → milestone inputs for the API. "Pay at once"
  /// sends no terms (backend uses a single 100% milestone).
  List<QuotePaymentTermInput> _buildPaymentTerms() {
    switch (_paymentTerm) {
      case '50/50':
        return const [
          QuotePaymentTermInput(
              label: 'On Confirmation', percentage: 50, dueLabel: 'Due on confirmation'),
          QuotePaymentTermInput(
              label: 'After Event', percentage: 50, dueLabel: 'After the event'),
        ];
      case '30/70':
        return const [
          QuotePaymentTermInput(
              label: 'On Confirmation', percentage: 30, dueLabel: 'Due on confirmation'),
          QuotePaymentTermInput(
              label: 'After Event', percentage: 70, dueLabel: 'After the event'),
        ];
      case 'Custom':
        return [
          QuotePaymentTermInput(
              label: 'Milestone 1',
              percentage: double.tryParse(_m1PercentCtrl.text) ?? 50,
              dueLabel: 'Due on confirmation'),
          QuotePaymentTermInput(
              label: 'Milestone 2',
              percentage: double.tryParse(_m2PercentCtrl.text) ?? 50,
              dueLabel: 'After the event'),
        ];
      default:
        return const [];
    }
  }

  Future<void> _submit() async {
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
        const SnackBar(
            content: Text('Add at least one line item with an amount')),
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
          paymentTerms: _buildPaymentTerms(),
          validUntil: DateTime.now().add(Duration(days: _validDays)),
          notes: note.isEmpty ? null : note,
        );
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Revised quote sent 🎉')),
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
          paymentTerms: _buildPaymentTerms(),
          validForDays: _validDays,
          notes: note.isEmpty ? null : note,
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
      return;
    }

    // ── Legacy booking-inquiry flow ──
    final bookingId = widget.bookingId;
    if (bookingId == null || bookingId.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Open this from a client chat or inquiry to send a quote')),
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
          if (_paymentTerm != 'Pay at once') 'Payment terms: $_paymentTerm',
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

  // For "Custom" milestone percentage controllers
  final TextEditingController _m1PercentCtrl =
      TextEditingController(text: '50');
  final TextEditingController _m2PercentCtrl =
      TextEditingController(text: '50');

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
      final terms = q.paymentTerms;
      if (terms.length == 2) {
        final p1 = terms[0].percentage.round();
        final p2 = terms[1].percentage.round();
        if (p1 == 50 && p2 == 50) {
          _paymentTerm = '50/50';
        } else if (p1 == 30 && p2 == 70) {
          _paymentTerm = '30/70';
        } else {
          _paymentTerm = 'Custom';
          _m1PercentCtrl.text = '$p1';
          _m2PercentCtrl.text = '$p2';
        }
      } else {
        _paymentTerm = 'Pay at once';
      }
    }

    _m1PercentCtrl.addListener(() => setState(() {}));
    _m2PercentCtrl.addListener(() => setState(() {}));
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
    _m1PercentCtrl.dispose();
    _m2PercentCtrl.dispose();
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
            'Quote valid for',
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
                opt,
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
                widget.reviseQuoteId != null ? 'Revise quote' : 'Create quote',
                style: GoogleFonts.urbanist(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                '${_conv?.participantName ?? 'Client'} · ${_conv?.eventName ?? 'Event'} · ${_formattedEventDate()}',
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
                hintText: 'Description',
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
                hintText: 'Amount',
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
            '+ Add Item',
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
        'Subtotal ${Formatters.formatCurrency(_subtotal)}',
        style: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: context.c.textPrimary,
        ),
      ),
    );
  }

  Widget _buildPaymentTermSelector() {
    final terms = ['Pay at once', '50/50', '30/70', 'Custom'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: terms.map((term) {
          final isActive = _paymentTerm == term;
          return GestureDetector(
            onTap: () => setState(() => _paymentTerm = term),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isActive ? AppColors.primary : context.c.border,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                term,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                      isActive ? AppColors.primary : context.c.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMilestoneCard({
    required int milestoneNumber,
    required int percent,
    required String dueLabel,
    bool editable = false,
    TextEditingController? percentCtrl,
  }) {
    final amount = (_subtotal * percent / 100).round();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surface,
        border: Border.all(color: context.c.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Milestone $milestoneNumber',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: context.c.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              if (editable && percentCtrl != null) ...[
                SizedBox(
                  width: 60,
                  child: TextField(
                    controller: percentCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.c.textPrimary,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: context.c.surfaceElevated,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  width: 60,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.c.surfaceElevated,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$percent',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.c.textPrimary,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 6),
              Text(
                '%',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                Formatters.formatCurrency(
                  editable && percentCtrl != null
                      ? (_subtotal *
                              (int.tryParse(percentCtrl.text) ?? 0) /
                              100)
                          .round()
                      : amount,
                ),
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  dueLabel,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: context.c.textSecondary,
                  ),
                ),
              ),
              Text(
                Formatters.formatCurrency(
                  editable && percentCtrl != null
                      ? (_subtotal *
                              (int.tryParse(percentCtrl.text) ?? 0) /
                              100)
                          .round()
                      : amount,
                ),
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: context.c.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMilestoneCards() {
    switch (_paymentTerm) {
      case '50/50':
        return [
          _buildMilestoneCard(
            milestoneNumber: 1,
            percent: 50,
            dueLabel: 'Due on booking confirmation (immediately)',
          ),
          _buildMilestoneCard(
            milestoneNumber: 2,
            percent: 50,
            dueLabel: '23rd May 2026',
          ),
        ];
      case '30/70':
        return [
          _buildMilestoneCard(
            milestoneNumber: 1,
            percent: 30,
            dueLabel: 'Due on booking confirmation (immediately)',
          ),
          _buildMilestoneCard(
            milestoneNumber: 2,
            percent: 70,
            dueLabel: '23rd May 2026',
          ),
        ];
      case 'Custom':
        return [
          _buildMilestoneCard(
            milestoneNumber: 1,
            percent: int.tryParse(_m1PercentCtrl.text) ?? 50,
            dueLabel: 'Due on booking confirmation (immediately)',
            editable: true,
            percentCtrl: _m1PercentCtrl,
          ),
          _buildMilestoneCard(
            milestoneNumber: 2,
            percent: int.tryParse(_m2PercentCtrl.text) ?? 50,
            dueLabel: '23rd May 2026',
            editable: true,
            percentCtrl: _m2PercentCtrl,
          ),
        ];
      // 'Pay at once'
      default:
        return [
          _buildMilestoneCard(
            milestoneNumber: 1,
            percent: 100,
            dueLabel: 'Due on booking confirmation (immediately)',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.background,
      appBar: _buildGradientAppBar() as PreferredSizeWidget,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Line Items
            _buildSectionTitle('Line Items'),
            const SizedBox(height: 12),
            ...List.generate(_items.length, (i) => _buildLineItemRow(i)),
            const SizedBox(height: 8),
            _buildAddItemButton(),
            const SizedBox(height: 12),
            _buildSubtotalRow(),
            const SizedBox(height: 28),

            // Payment Terms
            _buildSectionTitle('Set your Payment Terms'),
            const SizedBox(height: 12),
            _buildPaymentTermSelector(),
            const SizedBox(height: 16),
            ..._buildMilestoneCards(),
            const SizedBox(height: 28),

            // Note to client
            _buildSectionTitle('Note to client'),
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
                hintText: 'Short description of the product',
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
            _buildSectionTitle('Quote valid for'),
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
                      _validFor,
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
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: context.c.surface,
          border: Border(
            top: BorderSide(color: context.c.border),
          ),
        ),
        child: AppButton.primary(
          _sending
              ? 'Sending…'
              : (widget.reviseQuoteId != null ? 'Send revised quote' : 'Create Quote'),
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
