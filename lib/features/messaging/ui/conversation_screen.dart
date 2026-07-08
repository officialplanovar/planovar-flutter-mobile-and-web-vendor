import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../core/services/chat_socket.dart';
import '../../../core/services/messaging_service.dart';
import '../../calls/call_screen.dart';
import '../../../core/services/bank_service.dart';
import '../../orders/data/bookings_repository.dart';
import '../../listings/data/listings_repository.dart';
import '../../../shared/models/bank_models.dart';
import '../../../shared/widgets/add_bank_account_sheet.dart';
import 'create_quote_screen.dart';
import '../data/quotes_repository.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/chat_card_models.dart';
import '../../../shared/models/conversation_model.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/models/message_model.dart';
import '../../../shared/widgets/chat_cards.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;

  const ConversationScreen({super.key, required this.conversationId});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _service = MessagingService();
  final _quotes = QuotesRepository();
  final _socket = ChatSocket();
  List<MessageModel> _messages = [];
  ConversationModel _conv = const ConversationModel(
    id: '',
    participantName: 'Conversation',
    unreadCount: 0,
  );
  String _currentUserId = '';
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  bool _hasDraft = false;
  BankAccount? _bankAccount;
  bool _bankLoaded = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthBloc>().state;
    if (auth is AuthAuthenticated) _currentUserId = auth.user.id;
    _resolveMyId();
    _loadBank();
    _load();
    _connectSocket();
    _textController.addListener(() {
      final hasDraft = _textController.text.trim().isNotEmpty;
      if (hasDraft != _hasDraft) {
        setState(() => _hasDraft = hasDraft);
      }
    });
  }

  @override
  void dispose() {
    _socket.leave(widget.conversationId);
    _socket.dispose();
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _resolveMyId() async {
    final id = await _service.myId();
    if (id != null && id.isNotEmpty && mounted && id != _currentUserId) {
      _currentUserId = id;
      await _load(); // re-parse — isMe is baked at parse time
    }
  }

  Future<void> _load() async {
    try {
      final msgs = await _service.getMessages(widget.conversationId, _currentUserId);
      final convos = await _service.getConversations();
      if (!mounted) return;
      setState(() {
        _messages = msgs;
        _conv = convos.firstWhere(
          (c) => c.id == widget.conversationId,
          orElse: () => _conv,
        );
      });
      _scrollToBottom();
    } catch (_) {
      // keep empty on error
    }
  }

  void _openCall() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CallScreen(
        conversationId: widget.conversationId,
        peerName: _conv.participantName,
      ),
    ));
  }

  void _startCall() {
    _socket.inviteCall(widget.conversationId);
    _openCall();
  }

  Future<void> _connectSocket() async {
    await _socket.connect();
    _socket.onReady(() => _socket.join(widget.conversationId));
    _socket.join(widget.conversationId);
    _socket.onCallIncoming((d) {
      if (d['conversationId'] != widget.conversationId) return;
      if (mounted) _openCall();
    });
    _socket.onMessage((data) {
      if (data['conversationId'] != widget.conversationId) return;
      final msg = MessagingService.msgFromSocket(data, _currentUserId);
      if (_messages.any((m) => m.id == msg.id)) return;
      if (!mounted) return;
      setState(() => _messages = [..._messages, msg]);
      _socket.markRead(widget.conversationId);
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _socket.sendMessage(conversationId: widget.conversationId, content: text);
    setState(() {
      _textController.clear();
      _hasDraft = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final conv = _conv;

    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          // ── Gradient AppBar ──────────────────────────────────────────────
          _ConversationAppBar(conv: conv, onCall: _startCall),

          // ── Chat Area (background + messages) ───────────────────────────
          Expanded(
            child: Stack(
              children: [
                // Geometric triangle tile background
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TriangleTilePainter(),
                  ),
                ),
                // Messages list
                ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) =>
                      _buildMessage(_messages[index]),
                ),
              ],
            ),
          ),

          // ── Bank-setup warning (a quote was accepted, no account yet) ────
          if (_needsBankAccount) _buildBankBanner(),

          // ── Contextual vendor action (quote / fulfilment) ────────────────
          if (conv.type != 'group') _buildBottomAction(conv),

          // ── Input Bar ────────────────────────────────────────────────────
          _InputBar(
            textController: _textController,
            hasDraft: _hasDraft,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(MessageModel msg) {
    final t = msg.typeLower;
    if (t == 'todo' && msg.todo != null) {
      return TodoCard(
        todo: msg.todo!,
        currentUserId: _currentUserId,
        onToggle: () => _toggleTodo(msg.todo!.id),
      );
    }
    if ((t == 'quote' || t == 'quote_revised') && msg.quote != null) {
      final q = msg.quote!;
      return QuoteCard(
        quote: q,
        onRevise: (q.isActive && q.status == 'pending' && !q.isExpired)
            ? () => _reviseQuote(q)
            : null,
      );
    }
    if (t == 'invoice' && msg.invoice != null) {
      return InvoiceCard(invoice: msg.invoice!);
    }
    if (t == 'order_request' && msg.booking != null) {
      final b = msg.booking!;
      return OrderRequestCard(
        booking: b,
        onAccept: b.status == 'pending' ? () => _acceptOrder(b.id) : null,
        onDecline: b.status == 'pending' ? () => _declineOrder(b.id) : null,
      );
    }
    if (t == 'quote_accepted' ||
        t == 'invoice_accepted' ||
        t == 'order_accepted' ||
        t == 'booking_confirmed') {
      return const ChatSystemBanner(
          label: 'Confirmed', color: Color(0xFF047857), bg: Color(0xFFF0FDF4));
    }
    if (t == 'quote_declined' ||
        t == 'quote_expired' ||
        t == 'order_declined' ||
        t == 'invoice_declined') {
      return ChatSystemBanner(
        label: t == 'quote_expired' ? 'Quote expired' : 'Declined',
        color: const Color(0xFFDC2626),
        bg: const Color(0xFFFEF2F2),
        icon: Icons.cancel_rounded,
      );
    }
    if (t == 'milestone_paid' || t == 'deposit_refunded') {
      final amt = msg.metadata['amount'];
      final refund = t == 'deposit_refunded';
      return ChatSystemBanner(
        label: refund
            ? (amt != null ? 'Deposit refunded · ₦$amt' : 'Deposit refunded')
            : (amt != null ? 'Payment received · ₦$amt' : 'Payment received'),
        color: const Color(0xFF047857),
        bg: const Color(0xFFF0FDF4),
        icon: Icons.payments_rounded,
      );
    }
    if (t == 'timeline_update') {
      return ChatSystemBanner(
        label: msg.content ?? 'Order update',
        color: AppColors.primary,
        bg: context.c.primaryLight,
        icon: Icons.local_shipping_rounded,
      );
    }
    if (t == 'review_requested') {
      return const ChatSystemBanner(
        label: 'Review requested',
        color: Color(0xFFB45309),
        bg: Color(0xFFFFFBEB),
        icon: Icons.star_rounded,
      );
    }
    if (t == 'review_submitted') {
      final r = msg.metadata['rating'];
      return ChatSystemBanner(
        label: r != null ? 'Client left a review · $r★' : 'Client left a review',
        color: const Color(0xFFB45309),
        bg: const Color(0xFFFFFBEB),
        icon: Icons.star_rounded,
      );
    }
    return _MessageBubble(message: msg);
  }

  /// The latest active (pending, not-expired) quote in this chat, if any.
  ChatQuote? _activeQuote() {
    for (final m in _messages.reversed) {
      final q = m.quote;
      if (q != null && q.isActive && q.status == 'pending' && !q.isExpired) {
        return q;
      }
    }
    return null;
  }

  Future<void> _loadBank() async {
    try {
      final a = await BankService().getMine();
      if (mounted) setState(() { _bankAccount = a; _bankLoaded = true; });
    } catch (_) {
      if (mounted) setState(() => _bankLoaded = true);
    }
  }

  bool get _needsBankAccount =>
      _bankLoaded &&
      _bankAccount == null &&
      _messages.any(
          (m) => m.typeLower == 'invoice' || m.typeLower == 'quote_accepted');

  Widget _buildBankBanner() {
    return Container(
      color: const Color(0xFFFEF3C7),
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      child: Row(
        children: [
          const Icon(Icons.account_balance_rounded, size: 20, color: Color(0xFFB45309)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Quote accepted — add your bank account to get paid.',
              style: GoogleFonts.urbanist(
                  fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF92400E)),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => showAddBankAccountSheet(
              context,
              onSaved: (a) {
                if (mounted) setState(() => _bankAccount = a);
              },
            ),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFB45309),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Add', style: GoogleFonts.urbanist(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  /// A booking that's confirmed but not yet delivered (fulfilment pending).
  ChatBookingRef? _fulfilableBooking() {
    if (_messages.any((m) =>
        m.typeLower == 'review_requested' || m.typeLower == 'review_submitted')) {
      return null; // already delivered
    }
    for (final m in _messages.reversed) {
      final b = m.booking;
      if (b != null && m.typeLower == 'invoice') return b;
    }
    return null;
  }

  Widget _buildBottomAction(ConversationModel conv) {
    final booking = _fulfilableBooking();
    if (booking != null) return _buildFulfilmentBar(booking);
    if (conv.clientId != null) return _buildQuoteActionBar();
    return const SizedBox.shrink();
  }

  Widget _buildFulfilmentBar(ChatBookingRef booking) {
    final isRental = booking.fulfilmentType == 'rental';
    final label = isRental ? 'Confirm return' : 'Mark delivered';
    return Container(
      color: context.c.surface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _postUpdate(booking.id),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('Post update',
                  style: GoogleFonts.urbanist(fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () => isRental ? _confirmReturn(booking.id) : _markDelivered(booking.id),
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF5756F5), Color(0xFF3332D4)]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(label,
                    style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReturn(String bookingId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.c.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Confirm rental return?',
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: ctx.c.textPrimary)),
        content: Text(
          'This completes the rental and refunds the client\'s deposit. '
          'Send the deposit back to the client from your bank.',
          style: GoogleFonts.urbanist(color: ctx.c.textSecondary),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Confirm return',
                  style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: AppColors.primary))),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await BookingsRepository().confirmReturn(bookingId);
      await _load();
      _snack('Rental completed — deposit refunded 🎉');
    } catch (e) {
      _snack(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _postUpdate(String bookingId) async {
    final ctrl = TextEditingController();
    final message = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.c.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Post an update',
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: ctx.c.textPrimary)),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          maxLines: 2,
          style: GoogleFonts.urbanist(color: ctx.c.textPrimary),
          decoration: InputDecoration(
            hintText: 'e.g. Out for delivery — arriving by 4pm',
            hintStyle: GoogleFonts.urbanist(color: ctx.c.textHint),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('Post')),
        ],
      ),
    );
    if (message == null || message.isEmpty) return;
    try {
      await BookingsRepository().postUpdate(bookingId, message);
      await _load();
      _snack('Update posted');
    } catch (e) {
      _snack(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _markDelivered(String bookingId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.c.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Mark as delivered?',
            style: GoogleFonts.urbanist(fontWeight: FontWeight.w800, color: ctx.c.textPrimary)),
        content: Text(
          'This completes the booking and asks the client to leave a review.',
          style: GoogleFonts.urbanist(color: ctx.c.textSecondary),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Mark delivered',
                  style: GoogleFonts.urbanist(fontWeight: FontWeight.w700, color: AppColors.primary))),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await BookingsRepository().markDelivered(bookingId);
      await _load();
      _snack('Marked as delivered 🎉');
    } catch (e) {
      _snack(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Widget _buildQuoteActionBar() {
    // Once a quote exists (active), the vendor revises it instead of creating new.
    final active = _activeQuote();
    final revising = active != null;
    return Container(
      color: context.c.surface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: OutlinedButton.icon(
        onPressed: revising ? () => _reviseQuote(active) : _openCreateQuote,
        icon: Icon(revising ? Icons.edit_rounded : Icons.description_outlined,
            size: 18, color: AppColors.primary),
        label: Text(revising ? 'Revise quote' : 'Create & send quote',
            style: GoogleFonts.urbanist(
                fontWeight: FontWeight.w700, color: AppColors.primary)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  void _snack(String m) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
    }
  }

  Future<void> _acceptOrder(String bookingId) async {
    try {
      await BookingsRepository().acceptOrder(bookingId);
      await _load();
      _snack('Order accepted — invoice sent 🎉');
    } catch (e) {
      _snack(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _declineOrder(String bookingId) async {
    try {
      await BookingsRepository().declineOrder(bookingId);
      await _load();
      _snack('Order declined');
    } catch (e) {
      _snack(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _openCreateQuote() async {
    final clientId = _conv.clientId;
    if (clientId == null) {
      _snack('Could not identify the client');
      return;
    }
    final listingId = await _pickListing();
    if (listingId == null || !mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CreateQuoteScreen(
        conversationId: widget.conversationId,
        clientId: clientId,
        listingId: listingId,
      ),
    ));
    await _load();
  }

  Future<void> _reviseQuote(ChatQuote quote) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CreateQuoteScreen(
        conversationId: widget.conversationId,
        reviseQuoteId: quote.id,
        initialQuote: quote,
      ),
    ));
    await _load();
  }

  /// Tick/untick the vendor's own task on a group to-do, then refresh.
  Future<void> _toggleTodo(String todoId) async {
    try {
      await _quotes.toggleTodo(todoId);
      await _load();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Couldn't update the task")),
        );
      }
    }
  }

  /// Bottom-sheet picker of the vendor's own listings to quote against.
  Future<String?> _pickListing() async {
    List<ListingModel> listings;
    try {
      listings = await ListingsRepository().listMine();
    } catch (_) {
      _snack('Could not load your listings');
      return null;
    }
    if (!mounted) return null;
    if (listings.isEmpty) {
      _snack('Add a listing first to send a quote');
      return null;
    }
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.c.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Text('Quote for which listing?',
                style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: ctx.c.textPrimary)),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final l in listings)
                    ListTile(
                      title: Text(l.title,
                          style: GoogleFonts.urbanist(
                              fontWeight: FontWeight.w600,
                              color: ctx.c.textPrimary)),
                      onTap: () => Navigator.pop(ctx, l.id),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ── Gradient AppBar ───────────────────────────────────────────────────────────
class _ConversationAppBar extends StatelessWidget {
  final ConversationModel conv;
  final VoidCallback? onCall;

  const _ConversationAppBar({required this.conv, this.onCall});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.fromLTRB(12, topPadding + 8, 12, 14),
      child: Row(
        children: [
          // Back arrow
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 36,
              height: 36,
              color: Colors.transparent,
              child: const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 6),
          // Avatar — group icon or single avatar
          if (conv.isGroup)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.group_rounded,
                  color: Colors.white, size: 26),
            )
          else
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white24,
              child: ClipOval(
                child: AppNetworkImage(
                  url: conv.participantImage,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    width: 48,
                    height: 48,
                    color: Colors.white24,
                    child: Center(
                      child: Text(
                        conv.participantName.isNotEmpty
                            ? conv.participantName[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Name + status / participants
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  conv.displayName,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                if (conv.isGroup)
                  Text(
                    '${conv.groupParticipantCount} participants',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  )
                else if (conv.eventName != null && conv.eventName!.isNotEmpty)
                  Text(
                    conv.eventName!,
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // Phone button
          GestureDetector(
            onTap: onCall,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: const Center(
                child: AppIcon('call', size: 17, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Triangle Tile Painter ─────────────────────────────────────────────────────
class _TriangleTilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const tileSize = 40.0;

    final cols = (size.width / tileSize).ceil() + 1;
    final rows = (size.height / tileSize).ceil() + 1;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = col * tileSize;
        final y = row * tileSize;

        // Upper-left triangle
        final path1 = Path()
          ..moveTo(x, y)
          ..lineTo(x + tileSize, y)
          ..lineTo(x, y + tileSize)
          ..close();
        canvas.drawPath(path1, paint);

        // Lower-right triangle
        final path2 = Path()
          ..moveTo(x + tileSize, y)
          ..lineTo(x + tileSize, y + tileSize)
          ..lineTo(x, y + tileSize)
          ..close();
        canvas.drawPath(path2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Message Bubble ────────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final MessageModel message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final timeStr = Formatters.time(message.createdAt);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10,
          left: isMe ? 60 : 0,
          right: isMe ? 0 : 60,
        ),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: isMe
              ? const LinearGradient(
                  colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isMe ? null : context.c.surface,
          borderRadius: isMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.content ?? '',
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: isMe ? Colors.white : context.c.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeStr,
              style: GoogleFonts.urbanist(
                fontSize: 10,
                color: isMe ? Colors.white70 : context.c.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quote Bubble ──────────────────────────────────────────────────────────────
// ── Input Bar ─────────────────────────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  final TextEditingController textController;
  final bool hasDraft;
  final VoidCallback onSend;

  const _InputBar({
    required this.textController,
    required this.hasDraft,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, bottomPadding + 8),
      decoration: BoxDecoration(
        color: context.c.surface,
        border: Border(top: BorderSide(color: context.c.border, width: 1)),
      ),
      child: Row(
        children: [
          // Attachment button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.c.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: AppIcon('attach', size: 17, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.c.surfaceElevated,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: textController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  color: context.c.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: GoogleFonts.urbanist(
                    fontSize: 15,
                    color: context.c.textHint,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: AppIcon('mic',
                        size: 15, color: context.c.textSecondary),
                  ),
                  suffixIconConstraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: AppIcon('send', size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
