import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/message_model.dart';
import '../../../shared/models/conversation_model.dart';
import '../../../shared/widgets/network_image_widget.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;

  const ConversationScreen({super.key, required this.conversationId});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  late List<MessageModel> _messages;
  late ConversationModel? _conversation;
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  bool _hasDraft = false;

  @override
  void initState() {
    super.initState();
    _messages = MockData.messagesForConversation(widget.conversationId);
    try {
      _conversation = MockData.conversations.firstWhere(
        (c) => c.id == widget.conversationId,
      );
    } catch (_) {
      _conversation = null;
    }
    _textController.addListener(() {
      final hasDraft = _textController.text.trim().isNotEmpty;
      if (hasDraft != _hasDraft) {
        setState(() => _hasDraft = hasDraft);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final newMsg = MessageModel(
      id: 'msg-new-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: widget.conversationId,
      senderId: 'vendor-001',
      content: text,
      type: 'TEXT',
      createdAt: DateTime.now(),
      isMe: true,
    );

    setState(() {
      _messages = [..._messages, newMsg];
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
    final conv = _conversation;
    final convIndex = conv != null ? MockData.conversations.indexOf(conv) : -1;
    final isOnline = convIndex >= 0 && convIndex < 2;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary),
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryLight,
                  child: ClipOval(
                    child: AppNetworkImage(
                      url: conv?.participantImage,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorWidget: Container(
                        width: 40,
                        height: 40,
                        color: AppColors.primaryLight,
                        child: Center(
                          child: Text(
                            conv?.participantName.isNotEmpty == true
                                ? conv!.participantName[0].toUpperCase()
                                : '?',
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conv?.participantName ?? 'Chat',
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: isOnline ? AppColors.success : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone_rounded, color: AppColors.textPrimary),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_rounded, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _MessageBubble(message: msg);
              },
            ),
          ),

          // Input bar
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file_rounded),
                  color: AppColors.textSecondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: AppColors.textHint,
                      ),
                      filled: true,
                      fillColor: AppColors.divider,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (!_hasDraft)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.mic_rounded),
                    color: AppColors.textSecondary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                if (_hasDraft) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
          bottom: 8,
          left: isMe ? 60 : 0,
          right: isMe ? 0 : 60,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.divider,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.content ?? '',
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: isMe ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              timeStr,
              style: GoogleFonts.urbanist(
                fontSize: 10,
                color: isMe
                    ? Colors.white.withValues(alpha: 0.6)
                    : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
