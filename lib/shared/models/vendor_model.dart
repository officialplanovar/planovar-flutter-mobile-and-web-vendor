import 'package:equatable/equatable.dart';

class VendorModel extends Equatable {
  final String id;
  final String businessName;
  final String slug;
  final String? description;
  final String? logoUrl;
  final String? coverUrl;
  final String? phone;
  final String? email;
  final List<String> tags;
  final List<String> portfolioUrls;
  final double ratingAvg;
  final int reviewCount;
  /// 'basic' | 'featured' | 'premium'
  final String subscriptionTier;
  final bool isVerified;
  final Map<String, dynamic>? location;

  const VendorModel({
    required this.id,
    required this.businessName,
    required this.slug,
    this.description,
    this.logoUrl,
    this.coverUrl,
    this.phone,
    this.email,
    this.tags = const [],
    this.portfolioUrls = const [],
    required this.ratingAvg,
    required this.reviewCount,
    required this.subscriptionTier,
    required this.isVerified,
    this.location,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] as String,
      businessName: json['businessName'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      tags: List<String>.from(json['tags'] as List? ?? []),
      portfolioUrls: List<String>.from(json['portfolioUrls'] as List? ?? []),
      // Prisma Decimal serializes as a String over JSON (e.g. "0") — tolerate both.
      ratingAvg: _toDouble(json['ratingAvg']),
      reviewCount: _toInt(json['reviewCount']),
      subscriptionTier: json['subscriptionTier'] as String? ?? 'basic',
      isVerified: json['isVerified'] as bool? ?? false,
      location: json['location'] as Map<String, dynamic>?,
    );
  }

  static double _toDouble(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'businessName': businessName,
        'slug': slug,
        'description': description,
        'logoUrl': logoUrl,
        'coverUrl': coverUrl,
        'phone': phone,
        'email': email,
        'tags': tags,
        'portfolioUrls': portfolioUrls,
        'ratingAvg': ratingAvg,
        'reviewCount': reviewCount,
        'subscriptionTier': subscriptionTier,
        'isVerified': isVerified,
        'location': location,
      };

  VendorModel copyWith({
    String? id,
    String? businessName,
    String? slug,
    String? description,
    String? logoUrl,
    String? coverUrl,
    String? phone,
    String? email,
    List<String>? tags,
    List<String>? portfolioUrls,
    double? ratingAvg,
    int? reviewCount,
    String? subscriptionTier,
    bool? isVerified,
    Map<String, dynamic>? location,
  }) {
    return VendorModel(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      tags: tags ?? this.tags,
      portfolioUrls: portfolioUrls ?? this.portfolioUrls,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      reviewCount: reviewCount ?? this.reviewCount,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      isVerified: isVerified ?? this.isVerified,
      location: location ?? this.location,
    );
  }

  bool get isFeatured => subscriptionTier == 'featured' || subscriptionTier == 'premium';

  @override
  List<Object?> get props => [id, businessName, slug, ratingAvg, subscriptionTier, isVerified];
}
