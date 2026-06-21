import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../reviews/data/reviews_repository.dart';

/// "My Reviews" — live reviews received by the vendor, with one-tap reply.
class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final _repo = ReviewsRepository();
  late Future<VendorReviewsPage> _future;

  @override
  void initState() {
    super.initState();
    _future = _repo.myVendorReviews();
  }

  void _reload() => setState(() => _future = _repo.myVendorReviews());

  Map<int, double> _breakdown(List<VendorReview> reviews) {
    if (reviews.isEmpty) return {for (var s = 1; s <= 5; s++) s: 0.0};
    final counts = <int, int>{for (var s = 1; s <= 5; s++) s: 0};
    for (final r in reviews) {
      counts[r.rating.clamp(1, 5)] = (counts[r.rating.clamp(1, 5)] ?? 0) + 1;
    }
    return {
      for (var s = 1; s <= 5; s++) s: (counts[s] ?? 0) / reviews.length,
    };
  }

  String _timeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays >= 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    return 'just now';
  }

  Future<void> _showReplySheet(VendorReview review) async {
    final ctrl = TextEditingController();
    var sending = false;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(
              24, 24, 24, 24 + MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reply to ${review.reviewerName}',
                  style: GoogleFonts.urbanist(
                      fontSize: 17, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              TextField(
                controller: ctrl,
                maxLines: 4,
                maxLength: 2000,
                decoration: const InputDecoration(
                  hintText: 'Thank them, or address their feedback…',
                ),
              ),
              const SizedBox(height: 12),
              AppButton.primary(
                sending ? 'Sending…' : 'Send reply',
                loading: sending,
                onTap: sending
                    ? null
                    : () async {
                        final text = ctrl.text.trim();
                        if (text.isEmpty) return;
                        setSheet(() => sending = true);
                        try {
                          await _repo.respond(review.id, text);
                          if (ctx.mounted) Navigator.pop(ctx);
                          _reload();
                        } catch (e) {
                          setSheet(() => sending = false);
                          if (ctx.mounted) {
                            ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                content: Text(e
                                    .toString()
                                    .replaceFirst('Exception: ', ''))));
                          }
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Gradient AppBar
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.only(
                top: topPadding + 12, left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('My Reviews',
                        style: GoogleFonts.urbanist(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    const SizedBox(height: 2),
                    Text("Reviews you've received from your past work",
                        style: GoogleFonts.urbanist(
                            fontSize: 13, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: FutureBuilder<VendorReviewsPage>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Could not load reviews',
                            style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: AppColors.textSecondary)),
                        const SizedBox(height: 12),
                        AppButton.secondary('Retry', onTap: _reload),
                      ],
                    ),
                  );
                }
                final page = snap.data!;
                if (page.reviews.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.reviews_outlined,
                            size: 44, color: AppColors.textHint),
                        const SizedBox(height: 12),
                        Text('No reviews yet',
                            style: GoogleFonts.urbanist(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text(
                            'Complete bookings and your client reviews will appear here.',
                            style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  );
                }
                final breakdown = _breakdown(page.reviews);
                return RefreshIndicator(
                  onRefresh: () async => _reload(),
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 40),
                    children: [
                      _buildSummaryCard(page, breakdown),
                      ...page.reviews.map(_buildReviewCard),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
      VendorReviewsPage page, Map<int, double> breakdown) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final fraction = breakdown[star] ?? 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Text('$star',
                          style: GoogleFonts.urbanist(
                              fontSize: 12,
                              color: AppColors.textSecondary)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppColors.divider,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: fraction,
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: AppColors.starColor,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 24),
          Column(
            children: [
              Text(page.averageRating.toStringAsFixed(1),
                  style: GoogleFonts.urbanist(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(Icons.star_rounded,
                      size: 16,
                      color: i < page.averageRating.floor()
                          ? AppColors.starColor
                          : AppColors.divider),
                ),
              ),
              const SizedBox(height: 4),
              Text('(${page.total} Reviews)',
                  style: GoogleFonts.urbanist(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(VendorReview review) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.primaryLight,
                child: review.reviewerImage != null
                    ? ClipOval(
                        child: AppNetworkImage(
                          url: review.reviewerImage,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Text(
                        review.reviewerName.isNotEmpty
                            ? review.reviewerName[0].toUpperCase()
                            : '?',
                        style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.reviewerName,
                        style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(Icons.star_rounded,
                              size: 14,
                              color: i < review.rating
                                  ? AppColors.starColor
                                  : AppColors.divider),
                        ),
                        const SizedBox(width: 4),
                        Text('${review.rating}.0 · ${_timeAgo(review.createdAt)}',
                            style: GoogleFonts.urbanist(
                                fontSize: 12,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              if (review.responseBody == null)
                TextButton.icon(
                  onPressed: () => _showReplySheet(review),
                  icon: const Icon(Icons.reply_rounded, size: 16),
                  label: Text('Reply',
                      style: GoogleFonts.urbanist(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (review.title != null) ...[
                  Text(review.title!,
                      style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                ],
                Text(review.body,
                    style: GoogleFonts.urbanist(
                        fontSize: 14, color: AppColors.textPrimary)),
                if (review.responseBody != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your reply',
                            style: GoogleFonts.urbanist(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary)),
                        const SizedBox(height: 2),
                        Text(review.responseBody!,
                            style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
