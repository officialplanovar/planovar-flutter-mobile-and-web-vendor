import '../../../core/api/api_client.dart';
import '../../../core/api/api_utils.dart';

class VendorReview {
  final String id;
  final String reviewerName;
  final String? reviewerImage;
  final int rating;
  final String? title;
  final String body;
  final DateTime createdAt;
  final String? responseBody;

  const VendorReview({
    required this.id,
    required this.reviewerName,
    this.reviewerImage,
    required this.rating,
    this.title,
    required this.body,
    required this.createdAt,
    this.responseBody,
  });

  factory VendorReview.fromJson(Map<String, dynamic> json) {
    final reviewer = json['reviewer'] as Map?;
    final response = json['response'] as Map?;
    return VendorReview(
      id: json['id'] as String,
      reviewerName: reviewer?['name'] as String? ?? 'Client',
      reviewerImage: reviewer?['image'] as String?,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
      body: json['body'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      responseBody: response?['body'] as String?,
    );
  }
}

class VendorReviewsPage {
  final List<VendorReview> reviews;
  final int total;
  final double averageRating;
  const VendorReviewsPage({
    required this.reviews,
    required this.total,
    required this.averageRating,
  });
}

class ReviewsRepository {
  final ApiClient _api;
  ReviewsRepository({ApiClient? api}) : _api = api ?? ApiClient();

  /// Reviews received by the current vendor (resolves vendor id via /vendors/me).
  Future<VendorReviewsPage> myVendorReviews({int take = 50}) async {
    final me = await _api.dio.get('/vendors/me');
    ensureOk(me);
    final vendorId = (me.data as Map)['id'] as String;

    final res = await _api.dio
        .get('/reviews/vendor/$vendorId', queryParameters: {'take': take});
    ensureOk(res);
    final map = Map<String, dynamic>.from(res.data);
    final meta = Map<String, dynamic>.from(map['meta'] as Map? ?? {});
    return VendorReviewsPage(
      reviews: (map['data'] as List? ?? const [])
          .map((e) => VendorReview.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      total: (meta['total'] as num?)?.toInt() ?? 0,
      averageRating:
          double.tryParse('${meta['averageRating'] ?? 0}') ?? 0,
    );
  }

  Future<void> respond(String reviewId, String body) async {
    final res =
        await _api.dio.post('/reviews/$reviewId/respond', data: {'body': body});
    ensureOk(res);
  }
}
