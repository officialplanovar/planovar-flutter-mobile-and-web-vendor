import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/mock/mock_data.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../../shared/widgets/status_chip.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ListingModel> _filterListings(int tabIndex) {
    final all = MockData.listings;
    switch (tabIndex) {
      case 1:
        return all
            .where((l) => !l.isRentable && l.pricingType != 'FIXED')
            .toList();
      case 2:
        return all
            .where((l) => !l.isRentable && l.pricingType == 'FIXED')
            .toList();
      case 3:
        return all.where((l) => l.isRentable).toList();
      default:
        return all;
    }
  }

  int get _serviceCount => MockData.listings
      .where((l) => !l.isRentable && l.pricingType != 'FIXED')
      .length;

  int get _productCount => MockData.listings
      .where((l) => !l.isRentable && l.pricingType == 'FIXED')
      .length;

  int get _rentalCount =>
      MockData.listings.where((l) => l.isRentable).length;

  bool get _hasOutOfStockItems => MockData.listings
      .any((l) => l.viewCount > 100 && !l.isActive);

  void _showDeleteDialog(BuildContext context, ListingModel listing) {
    final isService = listing.pricingType != 'FIXED' && !listing.isRentable;
    final label = isService ? 'Service' : 'Product';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.cancelledBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Delete $label',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to permanently delete this $label? This action cannot be undone.',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    'No, Keep',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(double.infinity, 52),
                      elevation: 0,
                    ),
                    child: Text(
                      'Yes, Delete',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeactivateDialog(BuildContext context, ListingModel listing) {
    final isService = listing.pricingType != 'FIXED' && !listing.isRentable;
    final label = isService ? 'Service' : 'Product';
    final isActive = listing.isActive;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7ED),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pause_circle_outline_rounded,
                color: Color(0xFFEA580C),
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isActive ? 'Deactivate $label' : 'Activate $label',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isActive
                  ? 'This will hide your $label from clients and stop new bookings.'
                  : 'This will make your $label visible to clients again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFED7AA)),
                ),
                child: Text(
                  'You currently have active Contacts tied to this service. Enquire or your service will auto-cancel after event date.',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: const Color(0xFFEA580C),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppButton.secondary(
                    'No, Continue',
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEA580C),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(double.infinity, 52),
                      elevation: 0,
                    ),
                    child: Text(
                      isActive ? 'Yes, Deactivate' : 'Yes, Activate',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildStatCell('Services', _serviceCount),
          _buildStatDivider(),
          _buildStatCell('Products', _productCount),
          _buildStatDivider(),
          _buildStatCell('Rentals', _rentalCount),
        ],
      ),
    );
  }

  Widget _buildStatCell(String label, int count) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$count',
            style: GoogleFonts.urbanist(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.border,
    );
  }

  Widget _buildOutOfStockBanner() {
    if (!_hasOutOfStockItems) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFEA580C),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '2 items are out of Stock. Click to update',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: const Color(0xFFEA580C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingCard(BuildContext context, ListingModel listing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: AppNetworkImage(
              url: listing.displayCoverUrl ?? '',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusChip(
                        status: listing.isActive ? 'active' : 'inactive',
                      ),
                      const Spacer(),
                      Text(
                        '${listing.viewCount} views',
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.title,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    listing.categoryName ?? '',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.basePrice != null
                        ? Formatters.formatCurrency(listing.basePrice!)
                        : 'Quote based',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Text(
                  'Edit',
                  style: GoogleFonts.urbanist(fontSize: 14),
                ),
              ),
              PopupMenuItem(
                value: 'deactivate',
                child: Text(
                  listing.isActive ? 'Deactivate' : 'Activate',
                  style: GoogleFonts.urbanist(fontSize: 14),
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                context.push(AppRoutes.editListingPath(listing.id));
              } else if (value == 'deactivate') {
                _showDeactivateDialog(context, listing);
              } else if (value == 'delete') {
                _showDeleteDialog(context, listing);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    final listings = _filterListings(tabIndex);
    if (listings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.store_outlined,
                size: 56, color: AppColors.textHint),
            const SizedBox(height: 12),
            Text(
              'No listings here yet',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap + to add your first listing',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
      itemCount: listings.length,
      itemBuilder: (context, index) =>
          _buildListingCard(context, listings[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'My Listings',
          style: GoogleFonts.urbanist(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => context.push(AppRoutes.addListing),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 22),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 2.5,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Services'),
            Tab(text: 'Products'),
            Tab(text: 'Rentals'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildStatBar(),
          _buildOutOfStockBanner(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(4, (i) => _buildTabContent(i)),
            ),
          ),
        ],
      ),
    );
  }
}
