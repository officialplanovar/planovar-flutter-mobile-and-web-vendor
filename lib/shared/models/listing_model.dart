import 'package:equatable/equatable.dart';

class ListingModel extends Equatable {
  final String id;
  final String vendorId;
  final String categoryId;
  final String title;
  final String? description;
  /// 'FIXED' | 'QUOTE' | 'HOURLY'
  final String pricingType;
  final double? basePrice;
  final bool isActive;
  final bool isFeatured;
  final bool isRentable;
  final double? perDayRate;
  final double? depositAmount;
  final List<String> tags;
  final double ratingAvg;
  final int reviewCount;
  final int viewCount;
  final DateTime createdAt;
  final List<String> mediaUrls;
  final String? coverUrl;
  final String? categoryName;

  const ListingModel({
    required this.id,
    required this.vendorId,
    required this.categoryId,
    required this.title,
    this.description,
    required this.pricingType,
    this.basePrice,
    required this.isActive,
    this.isFeatured = false,
    this.isRentable = false,
    this.perDayRate,
    this.depositAmount,
    this.tags = const [],
    this.ratingAvg = 0.0,
    this.reviewCount = 0,
    this.viewCount = 0,
    required this.createdAt,
    this.mediaUrls = const [],
    this.coverUrl,
    this.categoryName,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String,
      categoryId: json['categoryId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      pricingType: json['pricingType'] as String? ?? 'FIXED',
      basePrice: json['basePrice'] != null ? (json['basePrice'] as num).toDouble() : null,
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isRentable: json['isRentable'] as bool? ?? false,
      perDayRate: json['perDayRate'] != null ? (json['perDayRate'] as num).toDouble() : null,
      depositAmount: json['depositAmount'] != null ? (json['depositAmount'] as num).toDouble() : null,
      tags: List<String>.from(json['tags'] as List? ?? []),
      ratingAvg: (json['ratingAvg'] as num? ?? 0).toDouble(),
      reviewCount: json['reviewCount'] as int? ?? 0,
      viewCount: json['viewCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      mediaUrls: List<String>.from(json['mediaUrls'] as List? ?? []),
      coverUrl: json['coverUrl'] as String?,
      categoryName: json['categoryName'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'vendorId': vendorId,
        'categoryId': categoryId,
        'title': title,
        'description': description,
        'pricingType': pricingType,
        'basePrice': basePrice,
        'isActive': isActive,
        'isFeatured': isFeatured,
        'isRentable': isRentable,
        'perDayRate': perDayRate,
        'depositAmount': depositAmount,
        'tags': tags,
        'ratingAvg': ratingAvg,
        'reviewCount': reviewCount,
        'viewCount': viewCount,
        'createdAt': createdAt.toIso8601String(),
        'mediaUrls': mediaUrls,
        'coverUrl': coverUrl,
        'categoryName': categoryName,
      };

  ListingModel copyWith({
    String? id,
    String? vendorId,
    String? categoryId,
    String? title,
    String? description,
    String? pricingType,
    double? basePrice,
    bool? isActive,
    bool? isFeatured,
    bool? isRentable,
    double? perDayRate,
    double? depositAmount,
    List<String>? tags,
    double? ratingAvg,
    int? reviewCount,
    int? viewCount,
    DateTime? createdAt,
    List<String>? mediaUrls,
    String? coverUrl,
    String? categoryName,
  }) {
    return ListingModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      pricingType: pricingType ?? this.pricingType,
      basePrice: basePrice ?? this.basePrice,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      isRentable: isRentable ?? this.isRentable,
      perDayRate: perDayRate ?? this.perDayRate,
      depositAmount: depositAmount ?? this.depositAmount,
      tags: tags ?? this.tags,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      reviewCount: reviewCount ?? this.reviewCount,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      coverUrl: coverUrl ?? this.coverUrl,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  String? get displayCoverUrl => coverUrl ?? (mediaUrls.isNotEmpty ? mediaUrls.first : null);

  @override
  List<Object?> get props => [id, vendorId, categoryId, title, pricingType, isActive, isRentable];
}
