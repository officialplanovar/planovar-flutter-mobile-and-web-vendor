import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _filter = 'All';
  final _filters = ['All', 'Orders', 'Payments', 'System'];
  final _service = NotificationService();
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final notifs = await _service.getNotifications();
      if (mounted) setState(() => _notifications = notifs);
    } catch (_) {
      // keep empty on error
    }
  }

  List<NotificationModel> get _filtered {
    if (_filter == 'All') return _notifications;
    if (_filter == 'Orders') {
      return _notifications
          .where((n) => n.type == 'booking' || n.type == 'quote')
          .toList();
    }
    if (_filter == 'Payments') {
      return _notifications
          .where((n) => n.type == 'payment' || n.type == 'payout')
          .toList();
    }
    return _notifications
        .where((n) => n.type == 'general' || n.type == 'review')
        .toList();
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'booking':
        return Icons.event_rounded;
      case 'quote':
        return Icons.request_quote_rounded;
      case 'payment':
        return Icons.payments_rounded;
      case 'payout':
        return Icons.account_balance_wallet_rounded;
      case 'review':
        return Icons.star_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _groupLabel(DateTime createdAt) {
    final now = DateTime.now();
    final diff = now.difference(createdAt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return 'Earlier';
  }

  void _markAllRead() {
    _service.markAllRead();
    setState(() {
      _notifications = _notifications
          .map((n) => NotificationModel(
                id: n.id,
                title: n.title,
                body: n.body,
                type: n.type,
                isRead: true,
                createdAt: n.createdAt,
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    // Group notifications
    final Map<String, List<NotificationModel>> grouped = {};
    for (final n in filtered) {
      final label = _groupLabel(n.createdAt);
      grouped.putIfAbsent(label, () => []).add(n);
    }

    final groupOrder = ['Today', 'Yesterday', 'Earlier'];
    final orderedGroups = groupOrder.where((g) => grouped.containsKey(g)).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary),
        title: Text(
          'Notifications',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: Text(
              'Mark all read',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final isSelected = _filter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : const Color(0xFFE9E9E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        f,
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Notification list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.notifications_off_outlined,
                            size: 56, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        Text(
                          'No notifications',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 40),
                    itemCount: orderedGroups.length,
                    itemBuilder: (context, groupIndex) {
                      final groupLabel = orderedGroups[groupIndex];
                      final items = grouped[groupLabel]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sticky group header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                            child: Text(
                              groupLabel,
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          ...items.map((notif) => _NotifTile(
                                notif: notif,
                                iconForType: _iconForType,
                                onTap: () {
                                  _service.markRead(notif.id);
                                  setState(() {
                                    final idx = _notifications.indexWhere((n) => n.id == notif.id);
                                    if (idx != -1) {
                                      _notifications[idx] = NotificationModel(
                                        id: notif.id,
                                        title: notif.title,
                                        body: notif.body,
                                        type: notif.type,
                                        isRead: true,
                                        createdAt: notif.createdAt,
                                      );
                                    }
                                  });
                                },
                              )),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final NotificationModel notif;
  final IconData Function(String) iconForType;
  final VoidCallback onTap;

  const _NotifTile({
    required this.notif,
    required this.iconForType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: notif.isRead
            ? Colors.transparent
            : AppColors.primaryLight.withValues(alpha: 0.5),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: notif.isRead ? AppColors.divider : AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconForType(notif.type),
              color: notif.isRead ? AppColors.textHint : AppColors.primary,
              size: 20,
            ),
          ),
          title: Text(
            notif.title,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              notif.body,
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Formatters.timeAgo(notif.createdAt),
                style: GoogleFonts.urbanist(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              if (!notif.isRead) ...[
                const SizedBox(height: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
