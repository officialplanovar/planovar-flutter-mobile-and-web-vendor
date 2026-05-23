import 'package:equatable/equatable.dart';
import 'top_listing_item_model.dart';

class AnalyticsModel extends Equatable {
  final double totalEarnings;
  final int totalOrders;
  final int profileViews;
  /// Fraction 0.0–1.0
  final double bookingRate;
  /// Earnings for each of the last 7 days (index 0 = oldest, 6 = today)
  final List<double> weeklyEarnings;
  final List<TopListingItem> topListings;

  const AnalyticsModel({
    required this.totalEarnings,
    required this.totalOrders,
    required this.profileViews,
    required this.bookingRate,
    required this.weeklyEarnings,
    required this.topListings,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      totalEarnings: (json['totalEarnings'] as num).toDouble(),
      totalOrders: json['totalOrders'] as int,
      profileViews: json['profileViews'] as int,
      bookingRate: (json['bookingRate'] as num).toDouble(),
      weeklyEarnings: List<double>.from(
        (json['weeklyEarnings'] as List).map((e) => (e as num).toDouble()),
      ),
      topListings: (json['topListings'] as List)
          .map((e) => TopListingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalEarnings': totalEarnings,
        'totalOrders': totalOrders,
        'profileViews': profileViews,
        'bookingRate': bookingRate,
        'weeklyEarnings': weeklyEarnings,
        'topListings': topListings.map((e) => e.toJson()).toList(),
      };

  AnalyticsModel copyWith({
    double? totalEarnings,
    int? totalOrders,
    int? profileViews,
    double? bookingRate,
    List<double>? weeklyEarnings,
    List<TopListingItem>? topListings,
  }) {
    return AnalyticsModel(
      totalEarnings: totalEarnings ?? this.totalEarnings,
      totalOrders: totalOrders ?? this.totalOrders,
      profileViews: profileViews ?? this.profileViews,
      bookingRate: bookingRate ?? this.bookingRate,
      weeklyEarnings: weeklyEarnings ?? this.weeklyEarnings,
      topListings: topListings ?? this.topListings,
    );
  }

  @override
  List<Object?> get props => [totalEarnings, totalOrders, profileViews, bookingRate];
}
