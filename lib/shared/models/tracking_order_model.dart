import 'package:equatable/equatable.dart';

/// Covers both Purchase and Rental product order tracking.
class TrackingOrderModel extends Equatable {
  final String id;
  final String orderNumber;

  /// 'purchase' | 'rental'
  final String orderType;

  final String productName;
  final String? productImage;
  final String clientName;
  final String? clientImage;
  final DateTime orderDate;

  /// Overall lifecycle:
  /// purchase: 'requested'|'confirmed'|'in_production'|'out_for_delivery'|'delivered'|'cancelled'
  /// rental  : 'requested'|'payment_confirmed'|'pickup_confirmed'|'out_for_delivery'|'return_confirmed'|'completed'|'cancelled'
  final String status;

  // ── Pricing ──────────────────────────────────────────────────────────────────
  final double amount;
  final double platformFee;
  final double deliveryCost;

  // ── Delivery ─────────────────────────────────────────────────────────────────
  final bool hasDelivery;
  final String? deliveryAddress;
  final String? deliveryRoute; // e.g. "Lagos → Abuja"
  final String? driverName;
  final String? driverPhone;

  // ── Rental-only ──────────────────────────────────────────────────────────────
  final DateTime? pickupTime;
  final DateTime? returnByTime;
  final double depositAmount;
  final double perDayRate;
  final int rentalDays;

  // ── Purchase timeline timestamps ──────────────────────────────────────────────
  /// Step 1: Order placed (always set)
  final DateTime orderPlacedAt;

  /// Step 2: Vendor accepted/confirmed
  final DateTime? vendorConfirmedAt;

  /// Step 3: Marked in production
  final DateTime? inProductionAt;

  /// Step 4: Sent for delivery
  final DateTime? outForDeliveryAt;

  /// Step 5: Marked delivered
  final DateTime? deliveredAt;

  // ── Rental timeline timestamps ────────────────────────────────────────────────
  final DateTime? paymentConfirmedAt;
  final DateTime? pickupConfirmedAt;
  final DateTime? returnConfirmedAt;

  /// Review submitted
  final DateTime? reviewedAt;

  const TrackingOrderModel({
    required this.id,
    required this.orderNumber,
    required this.orderType,
    required this.productName,
    this.productImage,
    required this.clientName,
    this.clientImage,
    required this.orderDate,
    required this.status,
    required this.amount,
    this.platformFee = 0,
    this.deliveryCost = 0,
    this.hasDelivery = false,
    this.deliveryAddress,
    this.deliveryRoute,
    this.driverName,
    this.driverPhone,
    this.pickupTime,
    this.returnByTime,
    this.depositAmount = 0,
    this.perDayRate = 0,
    this.rentalDays = 0,
    required this.orderPlacedAt,
    this.vendorConfirmedAt,
    this.inProductionAt,
    this.outForDeliveryAt,
    this.deliveredAt,
    this.paymentConfirmedAt,
    this.pickupConfirmedAt,
    this.returnConfirmedAt,
    this.reviewedAt,
  });

  // ── Computed helpers ──────────────────────────────────────────────────────────

  double get subtotal => amount + deliveryCost;
  double get total => subtotal + platformFee;

  /// Label shown on the list card chip
  String get statusLabel {
    switch (status) {
      case 'requested':
        return orderType == 'rental' ? 'Requested' : 'Order Placed';
      case 'confirmed':
        return 'Order Confirmed';
      case 'in_production':
        return 'In Production';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'payment_confirmed':
        return 'Payment Confirmed';
      case 'pickup_confirmed':
        return 'Pickup Confirmed';
      case 'return_confirmed':
        return 'Returned';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  /// Whether this order needs the vendor's immediate action
  bool get needsAction =>
      status == 'requested' ||
      (orderType == 'purchase' && status == 'confirmed') ||
      (orderType == 'rental' && status == 'payment_confirmed');

  TrackingOrderModel copyWith({
    String? id,
    String? orderNumber,
    String? orderType,
    String? productName,
    String? productImage,
    String? clientName,
    String? clientImage,
    DateTime? orderDate,
    String? status,
    double? amount,
    double? platformFee,
    double? deliveryCost,
    bool? hasDelivery,
    String? deliveryAddress,
    String? deliveryRoute,
    String? driverName,
    String? driverPhone,
    DateTime? pickupTime,
    DateTime? returnByTime,
    double? depositAmount,
    double? perDayRate,
    int? rentalDays,
    DateTime? orderPlacedAt,
    DateTime? vendorConfirmedAt,
    DateTime? inProductionAt,
    DateTime? outForDeliveryAt,
    DateTime? deliveredAt,
    DateTime? paymentConfirmedAt,
    DateTime? pickupConfirmedAt,
    DateTime? returnConfirmedAt,
    DateTime? reviewedAt,
  }) {
    return TrackingOrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      orderType: orderType ?? this.orderType,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      clientName: clientName ?? this.clientName,
      clientImage: clientImage ?? this.clientImage,
      orderDate: orderDate ?? this.orderDate,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      platformFee: platformFee ?? this.platformFee,
      deliveryCost: deliveryCost ?? this.deliveryCost,
      hasDelivery: hasDelivery ?? this.hasDelivery,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryRoute: deliveryRoute ?? this.deliveryRoute,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      pickupTime: pickupTime ?? this.pickupTime,
      returnByTime: returnByTime ?? this.returnByTime,
      depositAmount: depositAmount ?? this.depositAmount,
      perDayRate: perDayRate ?? this.perDayRate,
      rentalDays: rentalDays ?? this.rentalDays,
      orderPlacedAt: orderPlacedAt ?? this.orderPlacedAt,
      vendorConfirmedAt: vendorConfirmedAt ?? this.vendorConfirmedAt,
      inProductionAt: inProductionAt ?? this.inProductionAt,
      outForDeliveryAt: outForDeliveryAt ?? this.outForDeliveryAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      paymentConfirmedAt: paymentConfirmedAt ?? this.paymentConfirmedAt,
      pickupConfirmedAt: pickupConfirmedAt ?? this.pickupConfirmedAt,
      returnConfirmedAt: returnConfirmedAt ?? this.returnConfirmedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        orderType,
        status,
        vendorConfirmedAt,
        inProductionAt,
        outForDeliveryAt,
        deliveredAt,
        paymentConfirmedAt,
        pickupConfirmedAt,
        returnConfirmedAt,
        reviewedAt,
      ];
}
