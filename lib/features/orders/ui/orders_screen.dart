import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/mock/mock_data.dart';
import '../../../shared/models/booking_model.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/quote_request_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'Orders',
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          bottom: TabBar(
            labelStyle: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 2.5,
            tabs: const [
              Tab(text: 'Requests'),
              Tab(text: 'Bookings'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _RequestsTab(),
            _BookingsTab(
              bookings: MockData.bookings
                  .where((b) =>
                      b.status == 'CONFIRMED' || b.status == 'ACTIVE')
                  .toList(),
            ),
            _BookingsTab(
              bookings: MockData.bookings
                  .where((b) =>
                      b.status == 'COMPLETED' || b.status == 'CANCELLED')
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Requests Tab ─────────────────────────────────────────────────────────────

class _RequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quotes = MockData.pendingQuotes;

    if (quotes.isEmpty) {
      return const EmptyState(
        icon: Icons.inbox_outlined,
        title: 'No quote requests',
        subtitle: 'New client requests will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: quotes.length,
      itemBuilder: (context, index) {
        final quote = quotes[index];
        return QuoteRequestCard(
          key: ValueKey(quote.id),
          quote: quote,
          onRespond: () =>
              context.push(AppRoutes.orderDetailPath(quote.id)),
          onReject: () {},
          showSingleButton: false,
        );
      },
    );
  }
}

// ─── Bookings Tab (Bookings & History) ───────────────────────────────────────

class _BookingsTab extends StatelessWidget {
  final List<BookingModel> bookings;

  const _BookingsTab({required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'Nothing here yet',
        subtitle: 'Confirmed or completed bookings will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _BookingCard(
          booking: booking,
          onTap: () => context.push(AppRoutes.orderDetailPath(booking.id)),
        );
      },
    );
  }
}

// ─── Booking Card ─────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;

  const _BookingCard({required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        color: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.divider,
                    backgroundImage: (booking.clientImage != null &&
                            booking.clientImage!.isNotEmpty)
                        ? NetworkImage(booking.clientImage!)
                        : null,
                    child: (booking.clientImage == null ||
                            booking.clientImage!.isEmpty)
                        ? Text(
                            booking.clientName.isNotEmpty
                                ? booking.clientName[0]
                                : '?',
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.clientName,
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          booking.listingTitle,
                          style: GoogleFonts.urbanist(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusChip(status: booking.status),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoChip(
                    icon: Icons.event_outlined,
                    label: booking.eventName,
                  ),
                  const SizedBox(width: 12),
                  _InfoChip(
                    icon: Icons.calendar_today_outlined,
                    label: Formatters.formatDate(booking.eventDate),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Formatters.formatCurrency(booking.totalAmount),
                    style: GoogleFonts.urbanist(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'View details',
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Info Chip ────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
