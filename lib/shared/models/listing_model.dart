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
  final String? sku;
  final int? stockQuantity;
  final int? durationValue;
  final String? durationUnit;
  final String? cancellationPolicy;
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
    this.sku,
    this.stockQuantity,
    this.durationValue,
    this.durationUnit,
    this.cancellationPolicy,
    this.tags = const [],
    this.ratingAvg = 0.0,
    this.reviewCount = 0,
    this.viewCount = 0,
    required this.createdAt,
    this.mediaUrls = const [],
    this.coverUrl,
    this.categoryName,
  });

  /// Tolerant of the API shape: Prisma Decimals arrive as strings
  /// ("250000"), `category` is a nested object, and `media` is a list of
  /// {id,url,type,...} objects.
  factory ListingModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];
    final media = json['media'] as List?;
    return ListingModel(
      id: json['id'] as String,
      vendorId: json['vendorId'] as String? ?? '',
      categoryId: json['categoryId'] as String? ??
          (category is Map ? category['id'] as String? ?? '' : ''),
      title: json['title'] as String,
      description: json['description'] as String?,
      pricingType: json['pricingType'] as String? ?? 'FIXED',
      basePrice: _toDouble(json['basePrice']),
      isActive: json['isActive'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isRentable: json['isRentable'] as bool? ?? false,
      perDayRate: _toDouble(json['perDayRate']),
      depositAmount: _toDouble(json['depositAmount']),
      sku: json['sku'] as String?,
      stockQuantity: _toInt(json['stockQuantity']),
      durationValue: _toInt(json['durationValue']),
      durationUnit: json['durationUnit'] as String?,
      cancellationPolicy: json['cancellationPolicy'] as String?,
      tags: List<String>.from(json['tags'] as List? ?? []),
      ratingAvg: _toDouble(json['ratingAvg']) ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      viewCount: json['viewCount'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      mediaUrls: json['mediaUrls'] != null
          ? List<String>.from(json['mediaUrls'] as List)
          : (media ?? const [])
              .map((m) => m is Map ? m['url'] as String? : null)
              .whereType<String>()
              .toList(),
      coverUrl: json['coverUrl'] as String?,
      categoryName: json['categoryName'] as String? ??
          (category is Map ? category['name'] as String? : null),
    );
  }

  /// Accepts num or numeric string (Prisma Decimal serialization).
  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
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
        'sku': sku,
        'stockQuantity': stockQuantity,
        'durationValue': durationValue,
        'durationUnit': durationUnit,
        'cancellationPolicy': cancellationPolicy,
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
    String? sku,
    int? stockQuantity,
    int? durationValue,
    String? durationUnit,
    String? cancellationPolicy,
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
      sku: sku ?? this.sku,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      durationValue: durationValue ?? this.durationValue,
      durationUnit: durationUnit ?? this.durationUnit,
      cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
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
