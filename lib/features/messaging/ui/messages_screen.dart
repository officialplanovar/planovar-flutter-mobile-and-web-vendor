import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/messaging_service.dart';
import '../../../core/services/chat_socket.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/conversation_model.dart';
import '../../../shared/widgets/network_image_widget.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _searchController = TextEditingController();
  final _service = MessagingService();
  final _socket = ChatSocket();
  String _searchQuery = '';
  String _myId = '';
  List<ConversationModel> _all = [];

  @override
  void initState() {
    super.initState();
    _resolveMyId();
    _load();
    _connectSocket();
  }

  Future<void> _resolveMyId() async {
    final id = await _service.myId();
    if (id != null && mounted) _myId = id;
  }

  Future<void> _load() async {
    try {
      final convos = await _service.getConversations();
      if (!mounted) return;
      setState(() => _all = convos);
      _joinAll(); // join rooms for any new conversations
    } catch (_) {
      // keep empty on error
    }
  }

  /// Live-updates the list: joins every conversation room and refetches on any
  /// incoming message (updates preview, ordering and unread counts).
  Future<void> _connectSocket() async {
    await _socket.connect();
    _socket.onReady(_joinAll);
    _socket.onMessage(_onSocketMessage);
    _joinAll();
  }

  void _joinAll() {
    for (final c in _all) {
      _socket.join(c.id);
    }
  }

  /// Optimistically bump unread + preview + ordering on an incoming message
  /// (race-free vs a refetch). Unknown conversations trigger a refetch.
  void _onSocketMessage(Map<String, dynamic> data) {
    if (!mounted) return;
    final convId = data['conversationId'] as String?;
    if (convId == null) return;
    final idx = _all.indexWhere((c) => c.id == convId);
    if (idx < 0) {
      _load();
      return;
    }
    final senderId = data['senderId'] as String?;
    final content = data['content'] as String?;
    final mine = senderId != null && senderId == _myId;
    final bumped = _all[idx].copyWith(
      unreadCount: mine ? _all[idx].unreadCount : _all[idx].unreadCount + 1,
      lastMessage: content ?? _all[idx].lastMessage,
      lastMessageAt: DateTime.now(),
    );
    final list = [..._all]
      ..removeAt(idx)
      ..insert(0, bumped);
    setState(() => _all = list);
  }

  /// Clears a conversation's unread locally when opened.
  void _markReadLocal(String convId) {
    final idx = _all.indexWhere((c) => c.id == convId);
    if (idx >= 0 && _all[idx].unreadCount > 0) {
      final list = [..._all];
      list[idx] = list[idx].copyWith(unreadCount: 0);
      setState(() => _all = list);
    }
  }

  @override
  void dispose() {
    _socket.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversations = _all.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c.participantName
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          (c.lastMessage ?? '')
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          // ── Gradient Header ──────────────────────────────────────────────
          _MessagesHeader(searchController: _searchController, onSearch: (v) {
            setState(() => _searchQuery = v);
          }),

          // ── Conversation List ────────────────────────────────────────────
          Expanded(
            child: conversations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded,
                            size: 56, color: context.c.textHint),
                        const SizedBox(height: 12),
                        Text(
                          'No conversations found',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: context.c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 780),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: conversations.length,
                        itemBuilder: (context, index) {
                          final conv = conversations[index];
                          return _ConversationTile(
                            conv: conv,
                            onOpen: () => _markReadLocal(conv.id),
                          );
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Gradient Header ──────────────────────────────────────────────────────────
class _MessagesHeader extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const _MessagesHeader({
    required this.searchController,
    required this.onSearch,
  });

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
      padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Messages',
                      style: GoogleFonts.urbanist(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Stay connected with your clients',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Right: bell button with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  // Red badge
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE53935),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '1',
                          style: GoogleFonts.urbanist(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search bar
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(28),
            ),
            child: TextField(
              controller: searchController,
              onChanged: onSearch,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Search conversations',
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: Colors.white60,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                suffixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white60,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Conversation Tile ─────────────────────────────────────────────────────────
class _ConversationTile extends StatelessWidget {
  final ConversationModel conv;
  final VoidCallback? onOpen;

  const _ConversationTile({required this.conv, this.onOpen});

  Color? _statusDotColor() {
    switch (conv.status) {
      case 'disputed':
        return const Color(0xFFE53935);
      case 'completed':
        return const Color(0xFF27AE60);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = conv.unreadCount > 0;
    final statusDot = _statusDotColor();

    Color previewColor;
    if (conv.statusType == 'quote_requested') {
      previewColor = AppColors.primary;
    } else if (conv.statusType == 'quote_accepted') {
      previewColor = const Color(0xFF27AE60);
    } else if (conv.status == 'disputed') {
      previewColor = const Color(0xFFE53935);
    } else {
      previewColor = context.c.textSecondary;
    }

    final previewText = conv.statusLabel ?? conv.lastMessage ?? '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            onOpen?.call();
            context.push(AppRoutes.conversationPath(conv.id));
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            color: hasUnread
                ? context.c.primaryLight.withValues(alpha: 0.5)
                : context.c.surface,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ── Avatar ───────────────────────────────────────────────────
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Group: stacked mini-avatars; single: circle
                    if (conv.isGroup)
                      _GroupAvatarStack(avatars: conv.groupAvatars)
                    else
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: conv.type == 'support'
                            ? AppColors.primary
                            : context.c.divider,
                        child: ClipOval(
                          child: AppNetworkImage(
                            url: conv.participantImage,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorWidget: Container(
                              width: 56,
                              height: 56,
                              color: conv.type == 'support'
                                  ? AppColors.primary
                                  : context.c.primaryLight,
                              child: Center(
                                child: Icon(
                                  conv.type == 'support'
                                      ? Icons.support_agent_rounded
                                      : null,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Online dot (green)
                    if (conv.isOnline && !conv.isGroup)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF27AE60),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    // Status dot (disputed = red / completed = green)
                    if (statusDot != null && !conv.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: statusDot,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // ── Content ──────────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name row + time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                if (conv.isGroup)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Icon(Icons.group_rounded,
                                        size: 14,
                                        color: context.c.textSecondary),
                                  ),
                                Expanded(
                                  child: Text(
                                    conv.displayName,
                                    style: GoogleFonts.urbanist(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: context.c.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (conv.lastMessageAt != null)
                            Text(
                              Formatters.messageTime(conv.lastMessageAt!),
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                color: context.c.textSecondary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Preview + unread badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              previewText,
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: previewColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasUnread) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${conv.unreadCount}',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      // Group participant count
                      if (conv.isGroup) ...[
                        const SizedBox(height: 3),
                        Text(
                          '${conv.groupParticipantCount} participants',
                          style: GoogleFonts.urbanist(
                            fontSize: 11,
                            color: context.c.textHint,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1, thickness: 1, color: context.c.divider),
      ],
    );
  }
}

// ── Group Avatar Stack ────────────────────────────────────────────────────────
class _GroupAvatarStack extends StatelessWidget {
  final List<String> avatars;

  const _GroupAvatarStack({required this.avatars});

  @override
  Widget build(BuildContext context) {
    const size = 56.0;
    const miniSize = 28.0;
    const offset = 16.0;

    final urls = avatars.take(3).toList();
    if (urls.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.c.primaryLight,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.group_rounded,
            size: 24, color: AppColors.primary),
      );
    }

    // Render up to 3 mini circles, overlapping left→right
    return SizedBox(
      width: miniSize + offset * (urls.length - 1).clamp(0, 2) + 4,
      height: miniSize + 4,
      child: Stack(
        children: List.generate(urls.length, (i) {
          return Positioned(
            left: i * offset,
            top: 0,
            child: Container(
              width: miniSize,
              height: miniSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: AppNetworkImage(
                  url: urls[i],
                  width: miniSize,
                  height: miniSize,
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    color: context.c.primaryLight,
                    child: Center(
                      child: Text(
                        '?',
                        style: GoogleFonts.urbanist(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
