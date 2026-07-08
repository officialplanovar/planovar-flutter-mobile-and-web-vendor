import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/listings_cubit.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/network_image_widget.dart';

class OutOfStockScreen extends StatefulWidget {
  const OutOfStockScreen({super.key});

  @override
  State<OutOfStockScreen> createState() => _OutOfStockScreenState();
}

class _OutOfStockScreenState extends State<OutOfStockScreen> {
  int _selectedTab = 0;
  List<ListingModel> _all = const [];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ListingsCubit>();
    if (cubit.state.listings.isEmpty) cubit.load();
  }

  // ── Out-of-stock subset ────────────────────────────────────────────────────

  List<ListingModel> get _outOfStockAll =>
      _all.where((l) => !l.isActive).toList();

  List<ListingModel> get _outOfStockProducts =>
      _outOfStockAll.where((l) => l.pricingType == 'FIXED' && !l.isRentable).toList();

  List<ListingModel> get _outOfStockRentals =>
      _outOfStockAll.where((l) => l.isRentable).toList();

  List<ListingModel> get _filteredListings {
    switch (_selectedTab) {
      case 1:
        return _outOfStockProducts;
      case 2:
        return _outOfStockRentals;
      default:
        return _outOfStockAll;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Future<void> _reactivate(ListingModel listing) async {
    final cubit = context.read<ListingsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final noun = listing.pricingType == 'FIXED' && !listing.isRentable
        ? 'Product'
        : listing.isRentable
            ? 'Rental'
            : 'Service';
    try {
      await cubit.toggleActive(listing.id, true);
      messenger.showSnackBar(
        SnackBar(
          content: Text('$noun reactivated'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  String _listingTypeBadge(ListingModel listing) {
    if (listing.isRentable) return 'Product (Rental)';
    if (listing.pricingType == 'FIXED') return 'Product';
    return 'Service';
  }

  String _listingPrice(ListingModel listing) {
    if (listing.isRentable) {
      final rate = listing.perDayRate ?? listing.basePrice ?? 0;
      return '${Formatters.formatCurrency(rate)} / day';
    }
    if (listing.pricingType == 'FIXED') {
      return Formatters.formatCurrency(listing.basePrice ?? 0);
    }
    final min = listing.basePrice ?? 0;
    if (listing.basePrice != null) {
      final max = listing.basePrice! * 2;
      return '${Formatters.formatCurrency(min)} – ${Formatters.formatCurrency(max)}';
    }
    return 'Quote based';
  }

  // ── Gradient AppBar ────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SizedBox(
        height: topPadding + 64,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding),
          child: Row(
            children: [
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Listings out of stock',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Balance the back arrow
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  // ── Filter Tabs ────────────────────────────────────────────────────────────

  Widget _buildFilterTabs() {
    final tabs = [
      'All (${_outOfStockAll.length})',
      'Products (${_outOfStockProducts.length})',
      'Rentals (${_outOfStockRentals.length})',
    ];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final isActive = _selectedTab == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : context.c.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? AppColors.primary : context.c.border,
                ),
              ),
              child: Text(
                tabs[i],
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : context.c.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Out-of-Stock Card ──────────────────────────────────────────────────────

  Widget _buildCard(BuildContext context, ListingModel listing) {
    final typeBadge = _listingTypeBadge(listing);
    final price = _listingPrice(listing);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Red left accent bar
              Container(
                width: 4,
                color: AppColors.error,
              ),

              // Card content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AppNetworkImage(
                              url: listing.displayCoverUrl ?? '',
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  listing.title,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: context.c.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),

                                // Type badge + category
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: context.c.primaryLight,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        typeBadge,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    if (listing.categoryName != null) ...[
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          listing.categoryName!,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 12,
                                            color: context.c.textSecondary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),

                                // Price
                                Text(
                                  price,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: context.c.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Right column: out-of-stock badge + eye count
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Out of stock badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.cancelledBg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Out of Stock',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Eye + view count
                              Row(
                                children: [
                                  Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 13,
                                    color: context.c.textHint,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${listing.viewCount}',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 12,
                                      color: context.c.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Re stock button — reactivates the listing
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () => _reactivate(listing),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Re stock',
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
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
      ),
    );
  }

  // ── Empty State ────────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            size: 56,
            color: AppColors.success,
          ),
          const SizedBox(height: 12),
          Text(
            'All listings are in stock!',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.c.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'No out-of-stock items in this category',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: context.c.textHint,
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    _all = context.watch<ListingsCubit>().state.listings;
    final listings = _filteredListings;

    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          _buildAppBar(context),
          const SizedBox(height: 16),
          _buildFilterTabs(),
          const SizedBox(height: 12),
          Expanded(
            child: listings.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    itemCount: listings.length,
                    itemBuilder: (context, index) =>
                        _buildCard(context, listings[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
