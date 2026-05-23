import 'package:equatable/equatable.dart';

class BookingModel extends Equatable {
  final String id;
  final String clientId;
  final String clientName;
  final String? clientImage;
  final String vendorId;
  final String listingId;
  final String listingTitle;
  final String eventName;
  final DateTime eventDate;
  /// 'PENDING' | 'CONFIRMED' | 'ACTIVE' | 'COMPLETED' | 'CANCELLED'
  final String status;
  final double totalAmount;
  final DateTime createdAt;
  final String? escrowType;

  const BookingModel({
    required this.id,
    required this.clientId,
    required this.clientName,
    this.clientImage,
    required this.vendorId,
    required this.listingId,
    required this.listingTitle,
    required this.eventName,
    required this.eventDate,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    this.escrowType,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      clientName: json['clientName'] as String,
      clientImage: json['clientImage'] as String?,
      vendorId: json['vendorId'] as String,
      listingId: json['listingId'] as String,
      listingTitle: json['listingTitle'] as String,
      eventName: json['eventName'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      status: json['status'] as String? ?? 'PENDING',
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      escrowType: json['escrowType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clientId': clientId,
        'clientName': clientName,
        'clientImage': clientImage,
        'vendorId': vendorId,
        'listingId': listingId,
        'listingTitle': listingTitle,
        'eventName': eventName,
        'eventDate': eventDate.toIso8601String(),
        'status': status,
        'totalAmount': totalAmount,
        'createdAt': createdAt.toIso8601String(),
        'escrowType': escrowType,
      };

  BookingModel copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? clientImage,
    String? vendorId,
    String? listingId,
    String? listingTitle,
    String? eventName,
    DateTime? eventDate,
    String? status,
    double? totalAmount,
    DateTime? createdAt,
    String? escrowType,
  }) {
    return BookingModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientImage: clientImage ?? this.clientImage,
      vendorId: vendorId ?? this.vendorId,
      listingId: listingId ?? this.listingId,
      listingTitle: listingTitle ?? this.listingTitle,
      eventName: eventName ?? this.eventName,
      eventDate: eventDate ?? this.eventDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      escrowType: escrowType ?? this.escrowType,
    );
  }

  @override
  List<Object?> get props => [id, clientId, vendorId, listingId, status, eventDate];
}
