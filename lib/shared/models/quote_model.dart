import 'package:equatable/equatable.dart';
import 'quote_line_item_model.dart';

class QuoteModel extends Equatable {
  final String id;
  final String bookingId;
  final String vendorId;
  final String clientId;
  final String clientName;
  final String? clientImage;
  final String eventName;
  final DateTime eventDate;
  /// 'PENDING' | 'SENT' | 'ACCEPTED' | 'REJECTED'
  final String status;
  final double totalAmount;
  final String? notes;
  final List<QuoteLineItem> lineItems;
  final DateTime createdAt;
  final String? installmentType;

  const QuoteModel({
    required this.id,
    required this.bookingId,
    required this.vendorId,
    required this.clientId,
    required this.clientName,
    this.clientImage,
    required this.eventName,
    required this.eventDate,
    required this.status,
    required this.totalAmount,
    this.notes,
    this.lineItems = const [],
    required this.createdAt,
    this.installmentType,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      vendorId: json['vendorId'] as String,
      clientId: json['clientId'] as String,
      clientName: json['clientName'] as String,
      clientImage: json['clientImage'] as String?,
      eventName: json['eventName'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      status: json['status'] as String? ?? 'PENDING',
      totalAmount: (json['totalAmount'] as num).toDouble(),
      notes: json['notes'] as String?,
      lineItems: (json['lineItems'] as List? ?? [])
          .map((e) => QuoteLineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      installmentType: json['installmentType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookingId': bookingId,
        'vendorId': vendorId,
        'clientId': clientId,
        'clientName': clientName,
        'clientImage': clientImage,
        'eventName': eventName,
        'eventDate': eventDate.toIso8601String(),
        'status': status,
        'totalAmount': totalAmount,
        'notes': notes,
        'lineItems': lineItems.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        'installmentType': installmentType,
      };

  QuoteModel copyWith({
    String? id,
    String? bookingId,
    String? vendorId,
    String? clientId,
    String? clientName,
    String? clientImage,
    String? eventName,
    DateTime? eventDate,
    String? status,
    double? totalAmount,
    String? notes,
    List<QuoteLineItem>? lineItems,
    DateTime? createdAt,
    String? installmentType,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      vendorId: vendorId ?? this.vendorId,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      clientImage: clientImage ?? this.clientImage,
      eventName: eventName ?? this.eventName,
      eventDate: eventDate ?? this.eventDate,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
      lineItems: lineItems ?? this.lineItems,
      createdAt: createdAt ?? this.createdAt,
      installmentType: installmentType ?? this.installmentType,
    );
  }

  @override
  List<Object?> get props => [id, bookingId, vendorId, clientId, status, totalAmount];
}
