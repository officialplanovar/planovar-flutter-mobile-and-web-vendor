import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../models/chat_card_models.dart';

String _money(double v) {
  final s = v.toInt().toString();
  final b = StringBuffer('₦');
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return b.toString();
}

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
String _date(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

String _statusLabel(String s) {
  switch (s) {
    case 'accepted':
      return 'Accepted';
    case 'rejected':
    case 'declined':
      return 'Declined';
    case 'expired':
      return 'Expired';
    case 'superseded':
      return 'Superseded';
    case 'paid':
      return 'Paid';
    case 'partially_paid':
      return 'Partially paid';
    case 'cancelled':
      return 'Cancelled';
    case 'confirmed':
      return 'Confirmed';
    case 'sent':
      return 'Sent';
    default:
      return s.isEmpty ? '' : s[0].toUpperCase() + s.substring(1);
  }
}

class ChatSystemBanner extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;
  final IconData icon;
  const ChatSystemBanner({
    super.key,
    required this.label,
    required this.color,
    required this.bg,
    this.icon = Icons.check_circle_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.urbanist(
                    fontSize: 12.5, fontWeight: FontWeight.w700, color: color)),
          ]),
        ),
      ),
    );
  }
}

class _Shell extends StatelessWidget {
  final Color accent;
  final Color bg;
  final Widget child;
  const _Shell({required this.accent, required this.bg, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: child,
    );
  }
}

/// Vendor view of a quote they sent. Can revise while it's the active/pending one.
class QuoteCard extends StatelessWidget {
  final ChatQuote quote;
  final VoidCallback? onRevise;
  const QuoteCard({super.key, required this.quote, this.onRevise});

  @override
  Widget build(BuildContext context) {
    const amber = Color(0xFFB45309);
    final canRevise =
        onRevise != null && quote.isActive && quote.status == 'pending' && !quote.isExpired;
    return _Shell(
      accent: amber,
      bg: const Color(0xFFFFFBEB),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.description_rounded, size: 20, color: amber),
          const SizedBox(width: 8),
          Expanded(
            child: Text(quote.quoteNumber ?? 'Quote',
                style: GoogleFonts.urbanist(
                    fontSize: 15, fontWeight: FontWeight.w800, color: context.c.textPrimary)),
          ),
          if (quote.version > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20)),
              child: Text('v${quote.version}',
                  style: GoogleFonts.urbanist(
                      fontSize: 11, fontWeight: FontWeight.w700, color: amber)),
            ),
        ]),
        const SizedBox(height: 2),
        Text(
          quote.status == 'pending'
              ? 'Valid till ${_date(quote.validUntil)}'
              : _statusLabel(quote.status),
          style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w600, color: amber),
        ),
        const SizedBox(height: 10),
        ...quote.lineItems.map((li) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(children: [
                Expanded(
                  child: Text(li.label,
                      style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary)),
                ),
                Text(_money(li.amount),
                    style: GoogleFonts.urbanist(
                        fontSize: 13, fontWeight: FontWeight.w600, color: context.c.textPrimary)),
              ]),
            )),
        const Divider(height: 16),
        Row(children: [
          Text('Total', style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary)),
          const Spacer(),
          Text(_money(quote.amount),
              style: GoogleFonts.urbanist(fontSize: 17, fontWeight: FontWeight.w800, color: amber)),
        ]),
        if (canRevise) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onRevise,
              style: OutlinedButton.styleFrom(
                foregroundColor: amber,
                side: const BorderSide(color: amber),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Revise quote'),
            ),
          ),
        ],
      ]),
    );
  }
}

class InvoiceCard extends StatelessWidget {
  final ChatInvoice invoice;
  const InvoiceCard({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF047857);
    return _Shell(
      accent: green,
      bg: const Color(0xFFF0FDF4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.receipt_long_rounded, size: 20, color: green),
          const SizedBox(width: 8),
          Expanded(
            child: Text('Invoice · ${invoice.invoiceNumber}',
                style: GoogleFonts.urbanist(
                    fontSize: 15, fontWeight: FontWeight.w800, color: context.c.textPrimary)),
          ),
          Text(_statusLabel(invoice.status),
              style: GoogleFonts.urbanist(fontSize: 12, fontWeight: FontWeight.w700, color: green)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Text('Total', style: GoogleFonts.urbanist(fontSize: 13, color: context.c.textSecondary)),
          const Spacer(),
          Text(_money(invoice.total),
              style: GoogleFonts.urbanist(fontSize: 17, fontWeight: FontWeight.w800, color: green)),
        ]),
        if (invoice.milestones.isNotEmpty) ...[
          const SizedBox(height: 10),
          ...invoice.milestones.map((m) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(children: [
                  Icon(m.isPaid ? Icons.check_circle_rounded : Icons.schedule_rounded,
                      size: 15, color: m.isPaid ? green : context.c.textHint),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text('${m.label}${m.dueLabel != null ? ' · ${m.dueLabel}' : ''}',
                        style: GoogleFonts.urbanist(fontSize: 12, color: context.c.textSecondary)),
                  ),
                  Text(_money(m.amount),
                      style: GoogleFonts.urbanist(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: m.isPaid ? green : context.c.textPrimary)),
                ]),
              )),
        ],
      ]),
    );
  }
}

/// Incoming product/rental order request — the vendor accepts or declines.
class OrderRequestCard extends StatefulWidget {
  final ChatBookingRef booking;
  final Future<void> Function()? onAccept;
  final Future<void> Function()? onDecline;
  const OrderRequestCard({super.key, required this.booking, this.onAccept, this.onDecline});

  @override
  State<OrderRequestCard> createState() => _OrderRequestCardState();
}

class _OrderRequestCardState extends State<OrderRequestCard> {
  bool _busy = false;

  Future<void> _run(Future<void> Function()? fn) async {
    if (fn == null || _busy) return;
    setState(() => _busy = true);
    try {
      await fn();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    final pending = b.status == 'pending';
    return _Shell(
      accent: AppColors.primary,
      bg: context.c.surface,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.shopping_bag_rounded, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(b.listingTitle ?? 'Order request',
                style: GoogleFonts.urbanist(
                    fontSize: 14, fontWeight: FontWeight.w800, color: context.c.textPrimary)),
          ),
          if (b.total != null)
            Text(_money(b.total!),
                style: GoogleFonts.urbanist(
                    fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
        ]),
        const SizedBox(height: 4),
        Text(pending ? 'Client is requesting this — accept to send an invoice' : _statusLabel(b.status),
            style: GoogleFonts.urbanist(fontSize: 12, color: context.c.textSecondary)),
        if (pending && (widget.onAccept != null || widget.onDecline != null)) ...[
          const SizedBox(height: 12),
          Row(children: [
            if (widget.onDecline != null)
              Expanded(
                child: OutlinedButton(
                  onPressed: _busy ? null : () => _run(widget.onDecline),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    side: const BorderSide(color: Color(0xFFFECACA)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Decline'),
                ),
              ),
            if (widget.onDecline != null && widget.onAccept != null) const SizedBox(width: 10),
            if (widget.onAccept != null)
              Expanded(
                child: FilledButton(
                  onPressed: _busy ? null : () => _run(widget.onAccept),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _busy
                      ? const SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Accept'),
                ),
              ),
          ]),
        ],
      ]),
    );
  }
}

/// Group-chat to-do card. The client creates the to-do; each assignee (the
/// vendor included) ticks off their own task.
class TodoCard extends StatefulWidget {
  final ChatTodo todo;
  final String currentUserId;
  final Future<void> Function()? onToggle;

  const TodoCard({
    super.key,
    required this.todo,
    required this.currentUserId,
    this.onToggle,
  });

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.todo;
    final mine = t.mine(widget.currentUserId);
    return _Shell(
      accent: AppColors.primary,
      bg: context.c.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.checklist_rounded,
                size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(t.title,
                  style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: context.c.textPrimary)),
            ),
            Text('${t.doneCount}/${t.totalCount}',
                style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: context.c.textSecondary)),
          ]),
          if (t.description != null && t.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(t.description!,
                style: GoogleFonts.urbanist(
                    fontSize: 12.5, color: context.c.textSecondary)),
          ],
          if (t.dueAt != null) ...[
            const SizedBox(height: 4),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.schedule_rounded, size: 13, color: context.c.textHint),
              const SizedBox(width: 4),
              Text('Due ${_date(t.dueAt!)}',
                  style: GoogleFonts.urbanist(
                      fontSize: 11.5, color: context.c.textHint)),
            ]),
          ],
          if (mine != null && widget.onToggle != null) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _busy
                  ? null
                  : () async {
                      setState(() => _busy = true);
                      try {
                        await widget.onToggle!();
                      } finally {
                        if (mounted) setState(() => _busy = false);
                      }
                    },
              child: Row(children: [
                Icon(
                  mine.isDone
                      ? Icons.check_box_rounded
                      : Icons.check_box_outline_blank_rounded,
                  size: 20,
                  color: mine.isDone ? AppColors.primary : context.c.textHint,
                ),
                const SizedBox(width: 8),
                Text(
                    mine.isDone
                        ? 'You completed your task'
                        : 'Mark your task done',
                    style: GoogleFonts.urbanist(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: mine.isDone
                            ? AppColors.primary
                            : context.c.textPrimary)),
                if (_busy) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                ],
              ]),
            ),
          ],
        ],
      ),
    );
  }
}
