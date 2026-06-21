import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/chat_socket.dart';
import '../../../core/services/messaging_service.dart';
import '../../vendor/data/vendor_repository.dart';
import '../../calls/call_screen.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/conversation_model.dart';
import '../../../shared/models/message_model.dart';
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
  final _socket = ChatSocket();
  List<MessageModel> _messages = [];
  ConversationModel _conv = const ConversationModel(
    id: '',
    participantName: 'Conversation',
    unreadCount: 0,
  );
  String _currentUserId = '';
  String _vendorName = '';
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  bool _hasDraft = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthBloc>().state;
    if (auth is AuthAuthenticated) _currentUserId = auth.user.id;
    VendorRepository().getMe().then((v) {
      if (mounted && v != null) setState(() => _vendorName = v.businessName);
    }).catchError((_) {});
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
      backgroundColor: const Color(0xFFF5F5F5),
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
                  itemCount: _messages.length + _specialBubbleCount(conv),
                  itemBuilder: (context, index) {
                    if (index < _messages.length) {
                      return _MessageBubble(message: _messages[index]);
                    }
                    // Special bubbles after messages
                    final specialIndex = index - _messages.length;
                    return _buildSpecialBubble(conv, specialIndex);
                  },
                ),
              ],
            ),
          ),

          // ── Status Bar ───────────────────────────────────────────────────
          if (conv.quoteStatus != null)
            _StatusBar(quoteStatus: conv.quoteStatus!),

          // ── Action Card ──────────────────────────────────────────────────
          if (conv.quoteStatus != 'INVOICE_SENT')
            _ActionCard(conv: conv),

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

  int _specialBubbleCount(ConversationModel conv) {
    final qs = conv.quoteStatus;
    if (qs == null) return 0;
    if (qs == 'INVOICE_SENT') return 2; // quote + invoice
    return 1; // quote only
  }

  Widget _buildSpecialBubble(ConversationModel conv, int specialIndex) {
    if (specialIndex == 0) {
      return _QuoteBubble(vendorName: _vendorName);
    }
    // specialIndex == 1: invoice
    return const _InvoiceBubble();
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
    final isOnline = conv.isOnline;
    final rating = conv.ratingAvg.toStringAsFixed(1);

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
                else
                  Row(
                    children: [
                      Text(
                        isOnline ? 'Online' : 'Offline',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        ' · ',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        rating,
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.star_rounded,
                          color: AppColors.starColor, size: 13),
                    ],
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
              child: const Icon(Icons.call_outlined,
                  color: Colors.white, size: 20),
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
          color: Colors.white,
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
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeStr,
              style: GoogleFonts.urbanist(
                fontSize: 10,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Quote Bubble ──────────────────────────────────────────────────────────────
class _QuoteBubble extends StatelessWidget {
  final String vendorName;

  const _QuoteBubble({required this.vendorName});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFF5A623);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 40),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: gold, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    children: [
                      const Icon(Icons.description_outlined,
                          color: gold, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quote from $vendorName',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded,
                                    size: 12, color: gold),
                                const SizedBox(width: 4),
                                Text(
                                  'Valid till Midnight',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    color: gold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 12),
                  // Line items
                  _QuoteLineRow(label: 'Man power', amount: '₦85,000'),
                  const SizedBox(height: 6),
                  _QuoteLineRow(
                    label: 'Setup & delivery (Lekki)',
                    amount: '₦15,000',
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 12),
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '₦100,000',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: gold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Vendor avatar bottom-right outside card
            Positioned(
              bottom: -16,
              right: -8,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.divider,
                child: ClipOval(
                  child: AppNetworkImage(
                    url: null,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorWidget: Container(
                      width: 32,
                      height: 32,
                      color: AppColors.primaryLight,
                      child: Center(
                        child: Text(
                          vendorName.isNotEmpty ? vendorName[0] : 'V',
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuoteLineRow extends StatelessWidget {
  final String label;
  final String amount;

  const _QuoteLineRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          amount,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Invoice Bubble ────────────────────────────────────────────────────────────
class _InvoiceBubble extends StatelessWidget {
  const _InvoiceBubble();

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF27AE60);

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: green, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header row
            Row(
              children: [
                const Icon(Icons.description_outlined,
                    color: green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INVOICE · INV-2026-047',
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Sugared Dreams Cakery · 18 Feb 2026',
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Sent pill
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Sent',
                    style: GoogleFonts.urbanist(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 12),
            // Line items
            _QuoteLineRow(
              label: '3-tier fondant',
              amount: '₦85,000',
            ),
            const SizedBox(height: 6),
            _QuoteLineRow(
              label: 'Table centerpieces (20)',
              amount: '₦120,000',
            ),
            const SizedBox(height: 6),
            _QuoteLineRow(label: 'Setup', amount: '₦15,000'),
            const SizedBox(height: 12),
            // Payment schedule card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📅 Payment Schedule',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _PaymentMilestoneRow(
                    label: 'Milestone 1 · Now',
                    amount: '₦110,000',
                    pct: '50%',
                  ),
                  const SizedBox(height: 4),
                  _PaymentMilestoneRow(
                    label: 'Milestone 2 · 7 Mar',
                    amount: '₦110,000',
                    pct: '50%',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMilestoneRow extends StatelessWidget {
  final String label;
  final String amount;
  final String pct;

  const _PaymentMilestoneRow({
    required this.label,
    required this.amount,
    required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '$amount / $pct',
          style: GoogleFonts.urbanist(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Status Bar ────────────────────────────────────────────────────────────────
class _StatusBar extends StatelessWidget {
  final String quoteStatus;

  const _StatusBar({required this.quoteStatus});

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (quoteStatus == 'QUOTE_SENT') {
      content = Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: Color(0xFF27AE60), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Quote Sent',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: ' Awaiting client response',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else if (quoteStatus == 'QUOTE_ACCEPTED') {
      content = Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: Color(0xFF27AE60), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ngozi accepted this quote!',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF27AE60),
                  ),
                ),
                Text(
                  'Today at 10:05 AM · Ready to invoice',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // INVOICE_SENT
      content = Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: Color(0xFF27AE60), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Deposit ₦110k received · Next ₦110k on 7 Mar',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF27AE60),
                  ),
                ),
                Text(
                  'Today at 10:05 AM',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Container(
      color: const Color(0xFFE8F5E9),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: content,
    );
  }
}

// ── Action Card ───────────────────────────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final ConversationModel conv;

  const _ActionCard({required this.conv});

  @override
  Widget build(BuildContext context) {
    // KYC required
    if (conv.isKycRequired) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Please complete your KYC to continue.')),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F0),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.4), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: AppColors.error, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Incomplete KYC',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Complete your KYC to accept this request and generate a quote',
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.error, size: 20),
              ],
            ),
          ),
        ),
      );
    }

    // No quote yet
    if (conv.quoteStatus == null) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () =>
              context.push('${AppRoutes.createQuote}?convId=${conv.id}'),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF4544F4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.description_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create & send quote',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'With Flexible payment terms',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textSecondary, size: 20),
            ],
          ),
        ),
      );
    }

    // Quote sent or accepted → invoice action
    if (conv.quoteStatus == 'QUOTE_SENT' ||
        conv.quoteStatus == 'QUOTE_ACCEPTED') {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () =>
              context.push('${AppRoutes.createInvoice}?convId=${conv.id}'),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF4544F4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.receipt_long_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create & send Invoice',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Done negotiating? send a final invoice',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textSecondary, size: 20),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

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
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          // Attachment button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.attach_file_rounded,
                color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 8),
          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: textController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  hintStyle: GoogleFonts.urbanist(
                    fontSize: 15,
                    color: AppColors.textHint,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  suffixIcon: const Icon(Icons.mic_rounded,
                      color: AppColors.textSecondary, size: 20),
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
              child: Center(
                child: Transform.rotate(
                  angle: -math.pi / 4,
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
