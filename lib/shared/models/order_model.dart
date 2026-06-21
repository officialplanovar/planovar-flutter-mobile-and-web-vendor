import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String id;
  final String orderNumber;
  final String eventName;
  final String serviceName;
  final String vendorName;
  final String clientName;
  final String? clientImage;
  final String? thumbnailUrl;
  final DateTime eventDate;
  final String eventLocation;
  final String eventVenue;
  final int guestCount;
  final String category;
  final String duration;
  final String? additionalInfo;
  final double clientRating;
  final String accountNumber;
  final String bankName;
  final double amount;

  /// 'confirmed' | 'payment_pending' | 'completed' | 'cancelled'
  final String status;

  // Timeline step completion timestamps (null = not yet done)
  final DateTime? invoiceAcceptedAt;
  final DateTime? paymentConfirmedAt;
  final DateTime? serviceDeliveredAt;
  final DateTime? reviewedAt;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.eventName,
    required this.serviceName,
    required this.vendorName,
    required this.clientName,
    this.clientImage,
    this.thumbnailUrl,
    required this.eventDate,
    required this.eventLocation,
    required this.eventVenue,
    required this.guestCount,
    required this.category,
    required this.duration,
    this.additionalInfo,
    required this.clientRating,
    required this.accountNumber,
    required this.bankName,
    required this.amount,
    required this.status,
    this.invoiceAcceptedAt,
    this.paymentConfirmedAt,
    this.serviceDeliveredAt,
    this.reviewedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      eventName: json['eventName'] as String,
      serviceName: json['serviceName'] as String,
      vendorName: json['vendorName'] as String,
      clientName: json['clientName'] as String,
      clientImage: json['clientImage'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      eventDate: DateTime.parse(json['eventDate'] as String),
      eventLocation: json['eventLocation'] as String,
      eventVenue: json['eventVenue'] as String,
      guestCount: json['guestCount'] as int,
      category: json['category'] as String,
      duration: json['duration'] as String,
      additionalInfo: json['additionalInfo'] as String?,
      clientRating: (json['clientRating'] as num).toDouble(),
      accountNumber: json['accountNumber'] as String,
      bankName: json['bankName'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      invoiceAcceptedAt: json['invoiceAcceptedAt'] != null
          ? DateTime.parse(json['invoiceAcceptedAt'] as String)
          : null,
      paymentConfirmedAt: json['paymentConfirmedAt'] != null
          ? DateTime.parse(json['paymentConfirmedAt'] as String)
          : null,
      serviceDeliveredAt: json['serviceDeliveredAt'] != null
          ? DateTime.parse(json['serviceDeliveredAt'] as String)
          : null,
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'eventName': eventName,
      'serviceName': serviceName,
      'vendorName': vendorName,
      'clientName': clientName,
      'clientImage': clientImage,
      'thumbnailUrl': thumbnailUrl,
      'eventDate': eventDate.toIso8601String(),
      'eventLocation': eventLocation,
      'eventVenue': eventVenue,
      'guestCount': guestCount,
      'category': category,
      'duration': duration,
      'additionalInfo': additionalInfo,
      'clientRating': clientRating,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'amount': amount,
      'status': status,
      'invoiceAcceptedAt': invoiceAcceptedAt?.toIso8601String(),
      'paymentConfirmedAt': paymentConfirmedAt?.toIso8601String(),
      'serviceDeliveredAt': serviceDeliveredAt?.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? orderNumber,
    String? eventName,
    String? serviceName,
    String? vendorName,
    String? clientName,
    String? clientImage,
    String? thumbnailUrl,
    DateTime? eventDate,
    String? eventLocation,
    String? eventVenue,
    int? guestCount,
    String? category,
    String? duration,
    String? additionalInfo,
    double? clientRating,
    String? accountNumber,
    String? bankName,
    double? amount,
    String? status,
    DateTime? invoiceAcceptedAt,
    DateTime? paymentConfirmedAt,
    DateTime? serviceDeliveredAt,
    DateTime? reviewedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      eventName: eventName ?? this.eventName,
      serviceName: serviceName ?? this.serviceName,
      vendorName: vendorName ?? this.vendorName,
      clientName: clientName ?? this.clientName,
      clientImage: clientImage ?? this.clientImage,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      eventDate: eventDate ?? this.eventDate,
      eventLocation: eventLocation ?? this.eventLocation,
      eventVenue: eventVenue ?? this.eventVenue,
      guestCount: guestCount ?? this.guestCount,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      clientRating: clientRating ?? this.clientRating,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      invoiceAcceptedAt: invoiceAcceptedAt ?? this.invoiceAcceptedAt,
      paymentConfirmedAt: paymentConfirmedAt ?? this.paymentConfirmedAt,
      serviceDeliveredAt: serviceDeliveredAt ?? this.serviceDeliveredAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        status,
        invoiceAcceptedAt,
        paymentConfirmedAt,
        serviceDeliveredAt,
        reviewedAt,
      ];
}
