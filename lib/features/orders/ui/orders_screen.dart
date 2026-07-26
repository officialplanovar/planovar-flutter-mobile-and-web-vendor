import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/order_model.dart';
import '../../../shared/models/tracking_order_model.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../bloc/orders_cubit.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // 0 = My Bookings & Events, 1 = Order Tracking
  int _tabIndex = 0;
  // Bookings filter: 0 = Upcoming, 1 = Past, 2 = Cancelled
  int _filterIndex = 0;
  // Tracking filter: 0 = Purchase, 1 = Rentals, 2 = Completed, 3 = Cancelled
  int _trackingFilter = 0;

  static const _filters = ['Upcoming', 'Past', 'Cancelled'];
  static const _trackingFilters = ['Purchase', 'Rentals', 'Completed', 'Cancelled'];

  /// Live inquiries from the API (set from cubit state in build).
  List<OrderModel> _orders = const [];
  List<TrackingOrderModel> _tracking = const [];

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().load();
  }

  List<OrderModel> get _filteredOrders {
    switch (_filterIndex) {
      case 0:
        // Upcoming = awaiting response or confirmed
        return _orders
            .where((o) => o.status == 'PENDING' || o.status == 'CONFIRMED')
            .toList();
      case 1:
        return _orders.where((o) => o.status == 'COMPLETED').toList();
      case 2:
        return _orders.where((o) => o.status == 'CANCELLED').toList();
      default:
        return _orders;
    }
  }

  int get _activeCount => _orders
      .where((o) => o.status == 'PENDING' || o.status == 'CONFIRMED')
      .length;

  int get _needActionCount =>
      _orders.where((o) => o.status == 'PENDING').length;

  List<TrackingOrderModel> get _filteredTracking {
    // Live product/rental orders from the API (mapped from the vendor's bookings).
    final List<TrackingOrderModel> all = _tracking;
    switch (_trackingFilter) {
      case 0: // Purchase
        return all
            .where((o) =>
                o.orderType == 'purchase' &&
                o.status != 'delivered' &&
                o.status != 'cancelled')
            .toList();
      case 1: // Rentals
        return all
            .where((o) =>
                o.orderType == 'rental' &&
                o.status != 'return_confirmed' &&
                o.status != 'completed' &&
                o.status != 'cancelled')
            .toList();
      case 2: // Completed
        return all
            .where((o) =>
                o.status == 'delivered' ||
                o.status == 'return_confirmed' ||
                o.status == 'completed')
            .toList();
      case 3: // Cancelled
        return all.where((o) => o.status == 'cancelled').toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    // Live inquiries from the API.
    _orders = context.watch<OrdersCubit>().state.orders;
    _tracking = context.watch<OrdersCubit>().state.tracking;

    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          // ── Gradient Header ────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.only(
              top: topPadding + 16,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orders',
                  style: GoogleFonts.urbanist(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_activeCount active · $_needActionCount need action',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                // Toggle pill selector
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      _TogglePill(
                        label: 'My Bookings & Events',
                        selected: _tabIndex == 0,
                        onTap: () => setState(() => _tabIndex = 0),
                      ),
                      _TogglePill(
                        label: 'Order Tracking',
                        selected: _tabIndex == 1,
                        onTap: () => setState(() => _tabIndex = 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (_tabIndex == 0) ...[
            // ── Filter Pills ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                children: List.generate(_filters.length, (i) {
                  final selected = _filterIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() => _filterIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primaryDark
                            : context.c.surfaceElevated,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        _filters[i],
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : context.c.textSecondary,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ── Order List ─────────────────────────────────────────────
            Expanded(
              child: _filteredOrders.isEmpty
                  ? Center(
                      child: Text(
                        'No orders here yet.',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: context.c.textSecondary,
                        ),
                      ),
                    )
                  : Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 820),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 24),
                          itemCount: _filteredOrders.length,
                          itemBuilder: (context, index) {
                            return _OrderCard(order: _filteredOrders[index]);
                          },
                        ),
                      ),
                    ),
            ),
          ] else ...[
            // ── Tracking Filter Pills ──────────────────────────────────
            SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                itemCount: _trackingFilters.length,
                itemBuilder: (context, i) {
                  final selected = _trackingFilter == i;
                  return GestureDetector(
                    onTap: () => setState(() => _trackingFilter = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primaryDark
                            : context.c.surfaceElevated,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        _trackingFilters[i],
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected
                              ? Colors.white
                              : context.c.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Tracking List ──────────────────────────────────────────
            Expanded(
              child: _filteredTracking.isEmpty
                  ? Center(
                      child: Text(
                        'No orders here yet.',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          color: context.c.textSecondary,
                        ),
                      ),
                    )
                  : Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 820),
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.only(top: 8, bottom: 24),
                          itemCount: _filteredTracking.length,
                          itemBuilder: (context, index) {
                            return _TrackingCard(
                                order: _filteredTracking[index]);
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Tracking Card ───────────────────────────────────────────────────────────

class _TrackingCard extends StatelessWidget {
  final TrackingOrderModel order;
  const _TrackingCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final accentColor =
        order.needsAction ? const Color(0xFFE53935) : AppColors.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AppNetworkImage(
                            url: order.productImage,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.productName,
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: context.c.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Formatters.shortDate(order.orderDate),
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  color: context.c.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _TrackingStatusChip(status: order.status),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: context.c.primaryLight,
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      Formatters.currency(order.total),
                                      style: GoogleFonts.urbanist(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
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
                    // View Details button
                    GestureDetector(
                      onTap: () => context
                          .push(AppRoutes.trackingDetailPath(order.id)),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: context.c.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary,
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'View Details',
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrackingStatusChip extends StatelessWidget {
  final String status;
  const _TrackingStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String label;

    switch (status) {
      case 'requested':
        bg = AppColors.primaryLight;
        fg = AppColors.primary;
        label = 'Requested';
      case 'confirmed':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        label = 'Order Confirmed';
      case 'payment_confirmed':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        label = 'Payment Confirmed';
      case 'in_production':
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        label = 'In Production';
      case 'out_for_delivery':
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        label = 'Out for Delivery';
      case 'pickup_confirmed':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        label = 'Pickup Confirmed';
      case 'delivered':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        label = 'Delivered';
      case 'return_confirmed':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        label = 'Returned';
      case 'completed':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        label = 'Completed';
      case 'cancelled':
        bg = const Color(0xFFFFEBEE);
        fg = const Color(0xFFC62828);
        label = 'Cancelled';
      default:
        bg = context.c.divider;
        fg = context.c.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

// ─── Toggle Pill ──────────────────────────────────────────────────────────────

class _TogglePill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TogglePill({
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
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.primary : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Order Card ───────────────────────────────────────────────────────────────

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  bool get _isUpcoming =>
      order.status == 'confirmed' || order.status == 'payment_pending';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Row ────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AppNetworkImage(
                    url: order.thumbnailUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                // Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Event" pill chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: context.c.primaryLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Event',
                              style: GoogleFonts.urbanist(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${order.eventName} – ${order.category}',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: context.c.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${Formatters.shortDate(order.eventDate)} · ${order.eventVenue}',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          color: context.c.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status chip (top-right)
                _StatusChip(status: order.status),
              ],
            ),

            const SizedBox(height: 12),

            // ── Bottom Row (Actions) ───────────────────────────────────
            if (_isUpcoming)
              Row(
                children: [
                  Expanded(
                    child: _GradientButton(
                      label: 'View Details',
                      onTap: () =>
                          context.push(AppRoutes.orderDetailPath(order.id)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => context
                        .push(AppRoutes.conversationPath('conv-001')),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: context.c.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              )
            else
              _GradientButton(
                label: 'View Details',
                onTap: () =>
                    context.push(AppRoutes.orderDetailPath(order.id)),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Status Chip ──────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color textColor;
    final String label;

    switch (status) {
      case 'CONFIRMED':
      case 'confirmed':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        label = 'Confirmed';
      case 'PENDING':
      case 'payment_pending':
        bgColor = AppColors.pendingBg;
        textColor = AppColors.pendingText;
        label = 'Awaiting response';
      case 'COMPLETED':
      case 'completed':
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        label = 'Completed';
      case 'CANCELLED':
      case 'cancelled':
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        label = 'Cancelled';
      default:
        bgColor = context.c.divider;
        textColor = context.c.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

// ─── Gradient Button ──────────────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GradientButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6B6AF7), Color(0xFF3332D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
