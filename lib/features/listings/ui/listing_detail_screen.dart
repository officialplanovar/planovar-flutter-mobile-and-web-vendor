import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../bloc/listings_cubit.dart';
import '../../../shared/models/listing_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/network_image_widget.dart';

class ListingDetailScreen extends StatelessWidget {
  final String listingId;

  const ListingDetailScreen({super.key, required this.listingId});

  bool _isService(ListingModel listing) =>
      listing.pricingType != 'FIXED' && !listing.isRentable;

  String _typeLabel(ListingModel listing) {
    if (listing.isRentable) return 'Rental';
    if (_isService(listing)) return 'Service';
    return 'Product';
  }

  void _showDeleteDialog(BuildContext context, ListingModel listing) {
    final cubit = context.read<ListingsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final noun = _isService(listing) ? 'Service' : 'Product';
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => _DeleteDialog(
        listing: listing,
        onConfirm: () async {
          Navigator.of(dialogCtx).pop();
          try {
            await cubit.remove(listing.id);
            messenger.showSnackBar(
              SnackBar(
                content: Text('$noun deleted'),
                backgroundColor: AppColors.success,
              ),
            );
            if (router.canPop()) router.pop(); // leave the (now-gone) detail
          } catch (e) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(e.toString().replaceFirst('Exception: ', '')),
              ),
            );
          }
        },
      ),
    );
  }

  void _showDeactivateDialog(BuildContext context, ListingModel listing) {
    final cubit = context.read<ListingsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final noun = _isService(listing) ? 'Service' : 'Product';
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => _DeactivateDialog(
        listing: listing,
        onConfirm: () async {
          Navigator.of(dialogCtx).pop();
          try {
            await cubit.toggleActive(listing.id, false);
            messenger.showSnackBar(
              SnackBar(
                content: Text('$noun deactivated'),
                backgroundColor: AppColors.success,
              ),
            );
          } catch (e) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(e.toString().replaceFirst('Exception: ', '')),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lState = context.watch<ListingsCubit>().state;
    final matches = lState.listings.where((l) => l.id == listingId);
    if (matches.isEmpty) {
      return Scaffold(
        backgroundColor: context.c.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: context.c.textPrimary),
        ),
        body: Center(
          child: Text(
            lState.status == ListingsStatus.loading
                ? 'Loading…'
                : 'Listing not found',
            style: GoogleFonts.urbanist(color: context.c.textSecondary),
          ),
        ),
      );
    }
    final listing = matches.first;

    final isService = _isService(listing);
    final typeLabel = _typeLabel(listing);

    return Scaffold(
      backgroundColor: context.c.background,
      body: CustomScrollView(
        slivers: [
          // ── 1. Hero Image ────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: false,
            floating: false,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: AppNetworkImage(
                url: listing.coverUrl ??
                    (listing.mediaUrls.isNotEmpty
                        ? listing.mediaUrls.first
                        : null),
                fit: BoxFit.cover,
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 42,
                  height: 42,
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
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: context.c.textPrimary,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),

          // ── 2. Thumbnail Strip ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: listing.mediaUrls.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AppNetworkImage(
                        url: listing.mediaUrls[index],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // ── 3. Body ──────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Status chip
                  _StatusChip(isActive: listing.isActive),

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    listing.title,
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: context.c.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Metric cards row
                  _MetricCards(listing: listing),

                  const SizedBox(height: 16),

                  // Description
                  Text(
                    listing.description ?? '',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: context.c.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Details table
                  _DetailsTable(
                    listing: listing,
                    isService: isService,
                    typeLabel: typeLabel,
                  ),
                ],
              ),
            ),
          ),

          // ── 4. Action Buttons ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Edit button
                  AppButton.primary(
                    isService ? 'Edit Service' : 'Edit Product',
                    onTap: () =>
                        context.push('/listings/edit/${listing.id}'),
                  ),

                  const SizedBox(height: 12),

                  // Delete button
                  GestureDetector(
                    onTap: () => _showDeleteDialog(context, listing),
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Center(
                        child: Text(
                          isService ? 'Delete Service' : 'Delete Product',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Deactivate button
                  GestureDetector(
                    onTap: () => _showDeactivateDialog(context, listing),
                    child: Container(
                      height: 52,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppColors.error,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          isService
                              ? 'Deactivate Service'
                              : 'Deactivate Product',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
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
    );
  }
}

// ─── Status Chip ─────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final bool isActive;

  const _StatusChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? AppColors.activeBg : AppColors.pendingBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: GoogleFonts.urbanist(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isActive ? AppColors.activeText : AppColors.pendingText,
        ),
      ),
    );
  }
}

// ─── Metric Cards ─────────────────────────────────────────────────────────────

class _MetricCards extends StatelessWidget {
  final ListingModel listing;

  const _MetricCards({required this.listing});

  @override
  Widget build(BuildContext context) {
    // Real listing metrics. (Earnings/orders would need per-listing order
    // aggregation from the backend, which isn't available yet.)
    final rating = listing.reviewCount > 0
        ? '${listing.ratingAvg.toStringAsFixed(1)} (${listing.reviewCount})'
        : 'No reviews yet';
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
              label: 'Views (30d)', value: '${listing.viewCount}'),
        ),
        const SizedBox(width: 12),
        Expanded(child: _MetricCard(label: 'Rating', value: rating)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;

  const _MetricCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Details Table ────────────────────────────────────────────────────────────

class _DetailsTable extends StatelessWidget {
  final ListingModel listing;
  final bool isService;
  final String typeLabel;

  const _DetailsTable({
    required this.listing,
    required this.isService,
    required this.typeLabel,
  });

  String get _pricingTypeLabel {
    switch (listing.pricingType) {
      case 'FIXED':
        return 'Fixed price';
      case 'STARTING_FROM':
        return 'Starting from';
      case 'QUOTE':
        return 'Quote on request';
      default:
        return listing.pricingType;
    }
  }

  String get _durationLabel {
    if (listing.durationValue == null) return '—';
    final unit = listing.durationUnit ?? '';
    return '${listing.durationValue}${unit.isNotEmpty ? ' $unit' : ''}';
  }

  List<(String, String)> _buildRows() {
    final rows = <(String, String)>[];

    // ALL listings
    rows.add(('Type', typeLabel));

    String tagsValue() => listing.tags.isNotEmpty
        ? listing.tags.map((t) => '#$t').join(' ')
        : '—';

    if (listing.isRentable) {
      // Rental
      rows.add((
        'Price per day',
        listing.perDayRate != null
            ? Formatters.currency(listing.perDayRate!)
            : '—',
      ));
      rows.add((
        'Refundable Deposit',
        listing.depositAmount != null
            ? Formatters.currency(listing.depositAmount!)
            : '—',
      ));
      if (listing.sku != null && listing.sku!.isNotEmpty) {
        rows.add(('SKU', listing.sku!));
      }
      if (listing.stockQuantity != null) {
        rows.add(('Stock', '${listing.stockQuantity}'));
      }
      if (listing.cancellationPolicy != null &&
          listing.cancellationPolicy!.isNotEmpty) {
        rows.add(('Cancellation policy', listing.cancellationPolicy!));
      }
      rows.add(('Category', listing.categoryName ?? '—'));
    } else if (isService) {
      // Service (STARTING_FROM / QUOTE, !isRentable)
      final base = listing.basePrice ?? 0;
      final price =
          base > 0 ? 'From ${Formatters.currency(base)}' : 'Quote on request';
      rows.add(('Price', price));
      rows.add(('Pricing', _pricingTypeLabel));
      if (listing.durationValue != null) {
        rows.add(('Duration', _durationLabel));
      }
      if (listing.cancellationPolicy != null &&
          listing.cancellationPolicy!.isNotEmpty) {
        rows.add(('Cancellation policy', listing.cancellationPolicy!));
      }
      rows.add(('Category', listing.categoryName ?? '—'));
    } else {
      // Product (FIXED, !isRentable)
      rows.add((
        'Price',
        listing.basePrice != null
            ? Formatters.currency(listing.basePrice!)
            : '—',
      ));
      if (listing.sku != null && listing.sku!.isNotEmpty) {
        rows.add(('SKU', listing.sku!));
      }
      if (listing.stockQuantity != null) {
        rows.add(('Stock', '${listing.stockQuantity} in stock'));
      }
      rows.add(('Category', listing.categoryName ?? '—'));
    }

    // Common footer rows for every listing
    rows.add(('Status', listing.isActive ? 'Active' : 'Inactive'));
    rows.add(('Listed', Formatters.date(listing.createdAt)));
    rows.add(('Views (30d)', '${listing.viewCount}'));
    rows.add(('Tags', tagsValue()));

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final rows = _buildRows();

    return Container(
      decoration: BoxDecoration(
        color: context.c.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.c.border),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final index = entry.key;
          final (label, value) = entry.value;
          final isLast = index == rows.length - 1;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: context.c.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        value,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: context.c.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(height: 1, color: context.c.divider),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─── Delete Dialog ────────────────────────────────────────────────────────────

class _DeleteDialog extends StatelessWidget {
  final ListingModel listing;
  final VoidCallback onConfirm;

  const _DeleteDialog({required this.listing, required this.onConfirm});

  bool get _isService =>
      listing.pricingType != 'FIXED' && !listing.isRentable;

  String get _noun => _isService ? 'service' : 'product';
  String get _nounCap => _isService ? 'Service' : 'Product';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Red circle icon
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.error,
                size: 32,
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              'Delete $_nounCap',
              style: GoogleFonts.urbanist(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: context.c.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Are you sure you want to permanently delete this $_noun',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: context.c.textSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            // Buttons row
            Row(
              children: [
                Expanded(
                  child: AppButton.primary(
                    'Nevermind',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppColors.error,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Yes, Delete',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
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
}

// ─── Deactivate Dialog ────────────────────────────────────────────────────────

class _DeactivateDialog extends StatefulWidget {
  final ListingModel listing;
  final VoidCallback onConfirm;

  const _DeactivateDialog({required this.listing, required this.onConfirm});

  @override
  State<_DeactivateDialog> createState() => _DeactivateDialogState();
}

class _DeactivateDialogState extends State<_DeactivateDialog> {
  String? _selectedDuration;

  static const _durations = ['1 week', '2 weeks', '1 month', '3 months'];

  bool get _isService =>
      widget.listing.pricingType != 'FIXED' && !widget.listing.isRentable;

  String get _noun => _isService ? 'service' : 'product';
  String get _nounCap => _isService ? 'Service' : 'Product';

  void _showDurationPicker() {
    showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              Text(
                'Select Duration',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: context.c.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ..._durations.map((d) {
                return ListTile(
                  title: Text(
                    d,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: context.c.textPrimary,
                    ),
                  ),
                  trailing: _selectedDuration == d
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () {
                    Navigator.of(ctx).pop(d);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() => _selectedDuration = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close X button (top-right)
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: context.c.divider,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: context.c.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Red circle icon
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEBEB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.error,
                size: 32,
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              'Deactivate $_nounCap',
              style: GoogleFonts.urbanist(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: context.c.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Are you sure you want to temporarily deactivate this $_noun',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: context.c.textSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            // Deactivation Period
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Deactivation Period',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.c.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Dropdown-style selector
            GestureDetector(
              onTap: _showDurationPicker,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: context.c.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.c.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDuration ?? 'Select duration',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: _selectedDuration != null
                            ? context.c.textPrimary
                            : context.c.textHint,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: context.c.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Buttons row
            Row(
              children: [
                Expanded(
                  child: AppButton.primary(
                    'Nevermind',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onConfirm,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F0),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: AppColors.error,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Yes, Deactivate',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
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
}
