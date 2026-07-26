import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/app_button.dart';
import '../bloc/listings_cubit.dart';
import '../../vendor/data/vendor_repository.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  int _selectedTab = 0;

  /// Live listings from the API (set from cubit state in build).
  List<ListingModel> _all = const [];

  /// While unverified, this vendor's listings are hidden from clients.
  bool _vendorVerified = true; // optimistic — avoids a badge flash before load

  @override
  void initState() {
    super.initState();
    context.read<ListingsCubit>().load();
    VendorRepository().getMe().then((v) {
      if (mounted && v != null) {
        setState(() => _vendorVerified = v.isVerified);
      }
    }).catchError((_) {});
  }

  // ── Computed counts ──────────────────────────────────────────────────────────

  int get _allCount => _all.length;

  int get _serviceCount => _all
      .where((l) => l.pricingType != 'FIXED' && !l.isRentable)
      .length;

  int get _productCount => _all
      .where((l) => l.pricingType == 'FIXED' && !l.isRentable)
      .length;

  int get _rentalCount => _all.where((l) => l.isRentable).length;

  bool get _hasOutOfStock => _all.any((l) => !l.isActive);

  int get _outOfStockCount => _all.where((l) => !l.isActive).length;

  // ── Filter ────────────────────────────────────────────────────────────────────

  List<ListingModel> get _filteredListings {
    switch (_selectedTab) {
      case 1:
        return _all
            .where((l) => l.pricingType != 'FIXED' && !l.isRentable)
            .toList();
      case 2:
        return _all
            .where((l) => l.pricingType == 'FIXED' && !l.isRentable)
            .toList();
      case 3:
        return _all.where((l) => l.isRentable).toList();
      default:
        return _all;
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

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
    // QUOTE
    final min = listing.basePrice ?? 0;
    final max = listing.basePrice != null ? listing.basePrice! * 2 : 0;
    if (listing.basePrice != null) {
      return '${Formatters.formatCurrency(min)} – ${Formatters.formatCurrency(max)}';
    }
    return 'Quote based';
  }

  // ── Bottom Sheet (reused from HomeScreen logic) ────────────────────────────

  void _showListingTypeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) => _ListingTypeSheet(parentContext: context),
    );
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
                    'My Listings',
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
      'All ($_allCount)',
      'Services ($_serviceCount)',
      'Products ($_productCount)',
      'Rentals ($_rentalCount)',
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

  // ── Out-of-Stock Banner ────────────────────────────────────────────────────

  Widget _buildOutOfStockBanner(BuildContext context) {
    if (!_hasOutOfStock) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () => context.push(AppRoutes.listingsOutOfStock),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.c.textPrimary,
                  ),
                  children: [
                    TextSpan(
                      text: '$_outOfStockCount Items are out of Stock, ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(
                      text: 'Click to update',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.c.textHint,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // ── Listing Card ──────────────────────────────────────────────────────────

  Widget _buildListingCard(BuildContext context, ListingModel listing) {
    final isActive = listing.isActive;
    final typeBadge = _listingTypeBadge(listing);
    final price = _listingPrice(listing);

    return GestureDetector(
      onTap: () => context.push('/listings/detail/${listing.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
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

              // Right column: status + eye count
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Status chip (+ hidden-until-verified pill)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFDCFCE7)
                              : const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isActive ? 'Active' : 'Inactive',
                          style: GoogleFonts.urbanist(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? const Color(0xFF16A34A)
                                : const Color(0xFFEA580C),
                          ),
                        ),
                      ),
                      if (!_vendorVerified) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.visibility_off_outlined,
                                  size: 11, color: Color(0xFFEA580C)),
                              SizedBox(width: 3),
                              Text('Pending review',
                                  style: TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFEA580C),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ],
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
          Icon(
            Icons.store_outlined,
            size: 56,
            color: context.c.textHint,
          ),
          const SizedBox(height: 12),
          Text(
            'No listings here yet',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.c.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tap + to add your first listing',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: context.c.textHint,
            ),
          ),
        ],
      ),
    );
  }

  // ── FAB ────────────────────────────────────────────────────────────────────

  Widget _buildFAB(BuildContext context) {
    // The shell's bottom nav bar (≈64px + safe area) overlays this screen, so
    // lift the FAB above it instead of letting it sit underneath/clipped.
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 76,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _showListingTypeBottomSheet(context),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppIcon('add', size: 24, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Add listing',
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
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final lState = context.watch<ListingsCubit>().state;
    _all = lState.listings;
    final listings = _filteredListings;
    final isLoading =
        lState.status == ListingsStatus.loading && _all.isEmpty;

    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          _buildAppBar(context),
          const SizedBox(height: 16),
          _buildFilterTabs(),
          _buildOutOfStockBanner(context),
          const SizedBox(height: 12),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : lState.status == ListingsStatus.error && _all.isEmpty
                    ? _buildErrorState(lState.error)
                    : listings.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: () =>
                                context.read<ListingsCubit>().load(),
                            child: Center(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 820),
                                child: ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(
                                      20, 0, 20, 120),
                                  itemCount: listings.length,
                                  itemBuilder: (context, index) =>
                                      _buildListingCard(
                                          context, listings[index]),
                                ),
                              ),
                            ),
                          ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildErrorState(String? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded,
                size: 44, color: context.c.textHint),
            const SizedBox(height: 12),
            Text(
              error ?? 'Could not load your listings',
              style: GoogleFonts.urbanist(
                  fontSize: 14, color: context.c.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AppButton.secondary('Retry',
                onTap: () => context.read<ListingsCubit>().load()),
          ],
        ),
      ),
    );
  }
}

// ── Listing Type Bottom Sheet ──────────────────────────────────────────────────

class _ListingTypeSheet extends StatefulWidget {
  final BuildContext parentContext;

  const _ListingTypeSheet({required this.parentContext});

  @override
  State<_ListingTypeSheet> createState() => _ListingTypeSheetState();
}

class _ListingTypeSheetState extends State<_ListingTypeSheet> {
  String? _selected = 'service';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.c.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Cancel row
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            'Listing Type',
            style: GoogleFonts.urbanist(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: context.c.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Select the type of listing you want to create',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: context.c.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          _TypeCard(
            type: 'service',
            icon: Icons.work_outline_rounded,
            title: 'Service',
            subtitle: 'Bookable appointment',
            selected: _selected,
            onTap: (t) => setState(() => _selected = t),
          ),

          const SizedBox(height: 14),

          _TypeCard(
            type: 'product',
            icon: Icons.inventory_2_outlined,
            title: 'Product',
            subtitle: 'Physical item for rent or sale',
            selected: _selected,
            onTap: (t) => setState(() => _selected = t),
          ),

          const SizedBox(height: 28),

          AppButton.primary(
            'Proceed',
            onTap: _selected == null
                ? null
                : () {
                    Navigator.pop(context);
                    if (_selected == 'service') {
                      widget.parentContext.push(AppRoutes.addService);
                    } else {
                      widget.parentContext.push(AppRoutes.addProduct);
                    }
                  },
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String type;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? selected;
  final void Function(String) onTap;

  const _TypeCard({
    required this.type,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == type;
    return GestureDetector(
      onTap: () => onTap(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? context.c.primaryLight : context.c.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : context.c.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : context.c.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: context.c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? AppColors.primary : context.c.textHint,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
