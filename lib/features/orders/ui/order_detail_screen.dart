import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/order_model.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../bloc/orders_cubit.dart';

// ─── Main Screen ──────────────────────────────────────────────────────────────

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int _selectedTab = 0;
  bool _paymentConfirmed = false;
  bool _serviceDelivered = false;
  bool _acting = false;

  @override
  void initState() {
    super.initState();
    // Make sure the inquiries are loaded (e.g. deep-link straight to detail).
    final cubit = context.read<OrdersCubit>();
    if (cubit.state.orders.isEmpty) cubit.load();
  }

  Future<void> _runAction(Future<void> Function() action, String done) async {
    setState(() => _acting = true);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(done)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  // ─── Dialogs ────────────────────────────────────────────────────────────────

  void _showConfirmPaymentDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(),
                  child: Icon(
                    Icons.close,
                    color: context.c.textSecondary,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '⚠️',
                style: TextStyle(fontSize: 48),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Confirm Payment',
                style: GoogleFonts.urbanist(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: context.c.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Are you sure you have received the payment to your bank account?',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: context.c.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _GradientButton(
                      label: 'Yes, Confirm',
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      onTap: () {
                        setState(() => _paymentConfirmed = true);
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _GradientButton(
                      label: 'Not Yet',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE53935), Color(0xFFC62828)],
                      ),
                      onTap: () => Navigator.of(ctx).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showServiceDeliveredDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(),
                  child: Icon(
                    Icons.close,
                    color: context.c.textSecondary,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '⚠️',
                style: TextStyle(fontSize: 48),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Service Delivered?',
                style: GoogleFonts.urbanist(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: context.c.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Are you sure you have completed the service in its entirety',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: context.c.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _GradientButton(
                      label: 'Yes, Confirm',
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                      ),
                      onTap: () {
                        setState(() => _serviceDelivered = true);
                        Navigator.of(ctx).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _GradientButton(
                      label: 'Not Yet',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE53935), Color(0xFFC62828)],
                      ),
                      onTap: () => Navigator.of(ctx).pop(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Resolve the live booking from the cubit (rebuilds after actions).
    final orders = context.watch<OrdersCubit>().state.orders;
    final idx = orders.indexWhere((o) => o.id == widget.orderId);
    if (idx == -1) {
      return Scaffold(
        backgroundColor: context.c.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final order = orders[idx];

    return Scaffold(
      backgroundColor: context.c.background,
      bottomNavigationBar: _buildBottomBar(context, order),
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: AppNetworkImage(
                url: order.thumbnailUrl,
                fit: BoxFit.cover,
              ),
              stretchModes: const [StretchMode.zoomBackground],
            ),
            leading: Container(
              margin: const EdgeInsets.only(left: 16, top: 8),
              decoration: BoxDecoration(
                color: context.c.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: context.c.textPrimary,
                ),
                onPressed: () => context.pop(),
              ),
            ),
          ),

          // ── Body ──────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Event Info Section ─────────────────────────────────────
                _buildEventInfo(order),

                // ── Tab Toggle ─────────────────────────────────────────────
                _buildTabToggle(),

                // ── Tab Content ────────────────────────────────────────────
                _selectedTab == 0
                    ? _buildDetails(order)
                    : _buildTimeline(order),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Event Info ──────────────────────────────────────────────────────────────

  Widget _buildEventInfo(OrderModel order) {
    return Container(
      color: context.c.surface,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Event" pill chip
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: context.c.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star_border_rounded,
                  color: AppColors.primary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Event',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            order.eventName,
            style: GoogleFonts.urbanist(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: context.c.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _InfoItem(
                icon: Icons.calendar_today_outlined,
                text: Formatters.shortDate(order.eventDate),
              ),
              const SizedBox(width: 20),
              _InfoItem(
                icon: Icons.location_on_outlined,
                text: Formatters.shortDate(order.eventDate),
              ),
              const SizedBox(width: 20),
              _InfoItem(
                icon: Icons.people_outline_rounded,
                text: '${order.guestCount} guests',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Tab Toggle ──────────────────────────────────────────────────────────────

  Widget _buildTabToggle() {
    return Container(
      color: context.c.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          color: context.c.surfaceElevated,
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _TabButton(
              label: 'Details',
              selected: _selectedTab == 0,
              onTap: () => setState(() => _selectedTab = 0),
            ),
            _TabButton(
              label: 'Timeline',
              selected: _selectedTab == 1,
              onTap: () => setState(() => _selectedTab = 1),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Details Tab ─────────────────────────────────────────────────────────────

  Widget _buildDetails(OrderModel order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top order info row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppNetworkImage(
                url: order.thumbnailUrl,
                width: 64,
                height: 64,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.serviceName,
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: context.c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.vendorName,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: context.c.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFBBF24),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${order.clientRating}',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: context.c.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(height: 1, color: context.c.divider),
          const SizedBox(height: 12),

          // Icon-label rows
          _IconLabelRow(
            icon: Icons.work_outline_rounded,
            label: 'Category',
            value: order.category,
          ),
          const SizedBox(height: 12),
          _IconLabelRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: order.eventLocation,
          ),
          const SizedBox(height: 12),
          _IconLabelRow(
            icon: Icons.people_outline_rounded,
            label: 'Guest Size',
            value: '${order.guestCount}',
          ),
          const SizedBox(height: 12),
          _IconLabelRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date and Time',
            value: Formatters.date(order.eventDate),
          ),
          const SizedBox(height: 12),
          _IconLabelRow(
            icon: Icons.timer_outlined,
            label: 'Duration',
            value: order.duration,
          ),
          if (order.additionalInfo != null) ...[
            const SizedBox(height: 12),
            _IconLabelRow(
              icon: Icons.more_horiz_rounded,
              label: 'Additional Information',
              value: order.additionalInfo!,
            ),
          ],

          const SizedBox(height: 12),
          Divider(height: 1, color: context.c.divider),
          const SizedBox(height: 12),

          // "Reach out to Client privately" card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.c.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reach out to Client privately',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: context.c.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: context.c.divider,
                      child: ClipOval(
                        child: AppNetworkImage(
                          url: order.clientImage,
                          width: 44,
                          height: 44,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.clientName,
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: context.c.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFBBF24),
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${order.clientRating}',
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                color: context.c.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Call button
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.call_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Chat button
                    GestureDetector(
                      onTap: () => context
                          .push(AppRoutes.conversationPath('conv-001')),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Payment Received banner
          if (order.paymentConfirmedAt != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Payment Received',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Timeline Tab ─────────────────────────────────────────────────────────────

  Widget _buildTimeline(OrderModel order) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Timeline',
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.c.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Step 1: Invoice accepted
          _buildTimelineStep(
            stepNumber: 1,
            label: 'Invoice accepted',
            date: order.invoiceAcceptedAt,
            isCompleted: order.invoiceAcceptedAt != null,
            chipLabel: order.invoiceAcceptedAt != null ? 'Confirmed' : 'Pending',
            actionWidget: null,
            isLast: false,
          ),

          // Step 2: Payment confirmed
          _buildTimelineStep(
            stepNumber: 2,
            label: 'Payment confirmed',
            date: order.paymentConfirmedAt ?? order.invoiceAcceptedAt,
            isCompleted:
                order.paymentConfirmedAt != null || _paymentConfirmed,
            chipLabel: (order.paymentConfirmedAt != null || _paymentConfirmed)
                ? 'Completed'
                : 'Pending',
            actionWidget: _buildStep2Action(order),
            isLast: false,
          ),

          // Step 3: Event day
          _buildTimelineStep(
            stepNumber: 3,
            label: 'Event day',
            date: order.eventDate,
            isCompleted:
                order.serviceDeliveredAt != null || _serviceDelivered,
            chipLabel:
                (order.serviceDeliveredAt != null || _serviceDelivered)
                    ? 'Completed'
                    : 'Pending',
            actionWidget: _buildStep3Action(order),
            isLast: false,
          ),

          // Step 4: Review
          _buildTimelineStep(
            stepNumber: 4,
            label: 'Review',
            date: order.reviewedAt,
            isCompleted: order.reviewedAt != null,
            chipLabel: order.reviewedAt != null ? 'Completed' : 'Pending',
            actionWidget: _buildStep4Action(order),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Action(OrderModel order) {
    if (order.paymentConfirmedAt != null || _paymentConfirmed) {
      return _greenBanner('Payment received');
    } else if (order.invoiceAcceptedAt != null) {
      return _GradientButton(
        label: 'Confirm Payment',
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        onTap: _showConfirmPaymentDialog,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStep3Action(OrderModel order) {
    if (order.serviceDeliveredAt != null || _serviceDelivered) {
      return _greenBanner('Service Delivered');
    } else if (_paymentConfirmed || order.paymentConfirmedAt != null) {
      return _GradientButton(
        label: 'Service Delivered',
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        onTap: _showServiceDeliveredDialog,
      );
    }
    return _disabledPill('I have Delivered my service');
  }

  Widget _buildStep4Action(OrderModel order) {
    if (order.reviewedAt != null) {
      return _greenBanner('Review submitted');
    } else if (_serviceDelivered || order.serviceDeliveredAt != null) {
      return _GradientButton(
        label: 'Leave a Review',
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        onTap: () => context.push(AppRoutes.leaveReviewPath(order.id)),
      );
    }
    return _disabledPill('Leave a Review');
  }

  Widget _greenBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            '✓ $message',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _disabledPill(String label) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: context.c.border),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: context.c.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required int stepNumber,
    required String label,
    required DateTime? date,
    required bool isCompleted,
    required String chipLabel,
    required Widget? actionWidget,
    required bool isLast,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Step circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.primary : context.c.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      )
                    : Text(
                        '$stepNumber',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            // Step info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                  if (date != null)
                    Text(
                      Formatters.date(date),
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: context.c.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            // Status chip
            _StatusChip(label: chipLabel),
          ],
        ),

        // Action widget (indented 52px = 40 circle + 12 gap)
        if (actionWidget != null && actionWidget is! SizedBox) ...[
          Padding(
            padding: const EdgeInsets.only(left: 52, top: 10),
            child: actionWidget,
          ),
        ],

        // Dashed vertical connector
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 19, top: 4, bottom: 4),
            child: SizedBox(
              height: 24,
              child: CustomPaint(
                painter: _DashedLinePainter(),
                size: const Size(1.5, 24),
              ),
            ),
          ),
      ],
    );
  }

  // ─── Bottom Bar ───────────────────────────────────────────────────────────────

  Widget _buildBottomBar(BuildContext context, OrderModel order) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surface,
        border: Border(top: BorderSide(color: context.c.divider)),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Inquiry actions (status-driven, wired to the API) ────────────
          if (order.status == 'PENDING') ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE53935)),
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                    ),
                    onPressed: _acting
                        ? null
                        : () => _runAction(
                              () => order.isDirectOrder
                                  ? context
                                      .read<OrdersCubit>()
                                      .declineOrder(order.id)
                                  : context.read<OrdersCubit>().reject(order.id),
                              order.isDirectOrder
                                  ? 'Order declined'
                                  : 'Inquiry declined',
                            ),
                    child: Text('Decline',
                        style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFE53935))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GradientButton(
                    label: _acting
                        ? 'Working…'
                        : (order.isDirectOrder ? 'Accept Order' : 'Accept Inquiry'),
                    gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark]),
                    onTap: _acting
                        ? () {}
                        : () => _runAction(
                              () => order.isDirectOrder
                                  ? context
                                      .read<OrdersCubit>()
                                      .acceptOrder(order.id)
                                  : context.read<OrdersCubit>().confirm(order.id),
                              order.isDirectOrder
                                  ? 'Order accepted — invoice sent 🎉'
                                  : 'Inquiry accepted 🎉',
                            ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ] else if (order.status == 'CONFIRMED') ...[
            _GradientButton(
              label: _acting ? 'Working…' : 'Mark as Completed',
              gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)]),
              onTap: _acting
                  ? () {}
                  : () => _runAction(
                        () =>
                            context.read<OrdersCubit>().complete(order.id),
                        'Booking completed — client can now review',
                      ),
            ),
            const SizedBox(height: 10),
          ],
          if (order.status == 'PENDING' || order.status == 'CONFIRMED') ...[
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
              ),
              onPressed: () => context
                  .push(AppRoutes.createQuoteForBookingPath(order.id)),
              icon: const Icon(Icons.request_quote_outlined,
                  color: AppColors.primary, size: 20),
              label: Text('Send Quote',
                  style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
            ),
            const SizedBox(height: 10),
          ],
          // View Group Chat button
          GestureDetector(
            onTap: () =>
                context.push(AppRoutes.conversationPath('conv-001')),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'View Group Chat',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Cancel Order button
          GestureDetector(
            onTap: () =>
                context.push(AppRoutes.cancelOrderPath(order.id)),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE53935)),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              onPressed: () =>
                  context.push(AppRoutes.cancelOrderPath(order.id)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFE53935),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Cancel Order',
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE53935),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Supporting Widgets ───────────────────────────────────────────────────────

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? context.c.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight:
                    selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? AppColors.primary
                    : context.c.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconLabelRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _IconLabelRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: context.c.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.c.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted =
        label == 'Completed' || label == 'Confirmed';
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isCompleted
              ? const Color(0xFF27AE60)
              : const Color(0xFFFF8F00),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) => false;
}
