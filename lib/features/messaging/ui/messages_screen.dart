import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/mock/mock_data.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/network_image_widget.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  bool _showSearch = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final conversations = MockData.conversations.where((c) {
      if (_searchQuery.isEmpty) return true;
      return c.participantName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (c.lastMessage ?? '').toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Messages',
          style: GoogleFonts.urbanist(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
            icon: Icon(
              _showSearch ? Icons.close_rounded : Icons.search_rounded,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: GoogleFonts.urbanist(
                    fontSize: 15,
                    color: AppColors.textHint,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
                  filled: true,
                  fillColor: AppColors.divider,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            crossFadeState: _showSearch ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),

          // Conversation list
          Expanded(
            child: conversations.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.chat_bubble_outline_rounded,
                            size: 56, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        Text(
                          'No conversations found',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemCount: conversations.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      indent: 80,
                      endIndent: 20,
                      color: AppColors.divider,
                    ),
                    itemBuilder: (context, index) {
                      final conv = conversations[index];
                      final isOnline = index < 2;
                      final hasUnread = conv.unreadCount > 0;

                      return GestureDetector(
                        onTap: () => context.push(AppRoutes.conversationPath(conv.id)),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          color: hasUnread
                              ? AppColors.primaryLight.withValues(alpha: 0.3)
                              : Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            children: [
                              // Avatar with online indicator
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor: AppColors.divider,
                                    child: ClipOval(
                                      child: AppNetworkImage(
                                        url: conv.participantImage,
                                        width: 52,
                                        height: 52,
                                        fit: BoxFit.cover,
                                        errorWidget: Container(
                                          width: 52,
                                          height: 52,
                                          color: AppColors.primaryLight,
                                          child: Center(
                                            child: Text(
                                              conv.participantName.isNotEmpty
                                                  ? conv.participantName[0].toUpperCase()
                                                  : '?',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (conv.unreadCount > 0)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
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
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (isOnline)
                                    Positioned(
                                      bottom: 2,
                                      right: 2,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: AppColors.success,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            conv.participantName,
                                            style: GoogleFonts.urbanist(
                                              fontSize: 15,
                                              fontWeight: hasUnread
                                                  ? FontWeight.w700
                                                  : FontWeight.w600,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          conv.lastMessageAt != null ? Formatters.messageTime(conv.lastMessageAt!) : '',
                                          style: GoogleFonts.urbanist(
                                            fontSize: 11,
                                            color: hasUnread
                                                ? AppColors.primary
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            conv.lastMessage ?? '',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 13,
                                              color: hasUnread
                                                  ? AppColors.textPrimary
                                                  : AppColors.textSecondary,
                                              fontWeight: hasUnread
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (hasUnread) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              '${conv.unreadCount}',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
