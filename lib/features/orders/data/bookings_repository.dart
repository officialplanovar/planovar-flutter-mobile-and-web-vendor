import '../../../core/api/api_client.dart';
import '../../../core/api/api_utils.dart';
import '../../../shared/models/order_model.dart';
import '../../../shared/models/tracking_order_model.dart';

class InboxSummary {
  final int pending;
  final int confirmed;
  final int completed;
  final int cancelled;
  const InboxSummary({
    this.pending = 0,
    this.confirmed = 0,
    this.completed = 0,
    this.cancelled = 0,
  });
  int get actionNeeded => pending;

  factory InboxSummary.fromJson(Map<String, dynamic> json) => InboxSummary(
        pending: json['PENDING'] as int? ?? 0,
        confirmed: json['CONFIRMED'] as int? ?? 0,
        completed: json['COMPLETED'] as int? ?? 0,
        cancelled: json['CANCELLED'] as int? ?? 0,
      );
}

/// Vendor-side booking inquiries (payment-free model).
/// Maps API bookings into the UI's OrderModel.
class BookingsRepository {
  final ApiClient _api;
  BookingsRepository({ApiClient? api}) : _api = api ?? ApiClient();

  Future<List<OrderModel>> listMine({String? status}) async {
    final res = await _api.dio.get('/bookings', queryParameters: {
      if (status != null) 'status': status,
      'take': 50,
    });
    ensureOk(res);
    final list = res.data as List? ?? const [];
    return list
        .map((e) => _toOrder(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<InboxSummary> inboxSummary() async {
    final res = await _api.dio.get('/bookings/inbox/summary');
    ensureOk(res);
    return InboxSummary.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<void> confirm(String id) async =>
      ensureOk(await _api.dio.post('/bookings/$id/confirm'));

  Future<void> reject(String id, {String? reason}) async => ensureOk(
      await _api.dio.post('/bookings/$id/reject', data: {'reason': reason}));

  /// Accept a direct product/rental ORDER request — confirms the booking and
  /// generates a payable invoice (chat-order flow), broadcasting cards to the
  /// client in realtime.
  Future<void> acceptOrder(String bookingId) async =>
      ensureOk(await _api.dio.post('/chat-orders/orders/$bookingId/accept'));

  /// Decline a direct product/rental ORDER request — cancels the booking.
  Future<void> declineOrder(String bookingId) async =>
      ensureOk(await _api.dio.post('/chat-orders/orders/$bookingId/decline'));

  /// Post a progress update to the chat (TIMELINE_UPDATE card).
  Future<void> postUpdate(String bookingId, String message) async => ensureOk(
      await _api.dio.post('/chat-orders/bookings/$bookingId/update',
          data: {'message': message}));

  /// Mark the booking delivered → COMPLETED + review request to the client.
  Future<void> markDelivered(String bookingId) async =>
      ensureOk(await _api.dio.post('/chat-orders/bookings/$bookingId/deliver'));

  /// Confirm a rental was returned → COMPLETED + deposit refunded + review.
  Future<void> confirmReturn(String bookingId) async =>
      ensureOk(await _api.dio.post('/chat-orders/bookings/$bookingId/return'));

  Future<void> complete(String id) async =>
      ensureOk(await _api.dio.post('/bookings/$id/complete'));

  /// Product/rental orders for the Order-Tracking tab. Filters the vendor's
  /// bookings down to physical fulfilment (PURCHASE / RENTAL) — services are
  /// tracked in the chat, not here.
  Future<List<TrackingOrderModel>> tracking() async {
    final res = await _api.dio.get('/bookings', queryParameters: {'take': 100});
    ensureOk(res);
    final list = res.data as List? ?? const [];
    return list
        .map((e) => Map<String, dynamic>.from(e))
        .where((b) {
          final f = (b['fulfilmentType'] as String?)?.toUpperCase();
          return f == 'PURCHASE' || f == 'RENTAL';
        })
        .map(_toTracking)
        .toList();
  }

  // ── mapping ────────────────────────────────────────────────────────────

  OrderModel _toOrder(Map<String, dynamic> b) {
    final listing = b['listing'] as Map?;
    final client = b['client'] as Map?;
    final loc = b['eventLocation'];
    final amount = b['finalAmount'] ?? b['quoteAmount'];
    return OrderModel(
      id: b['id'] as String,
      orderNumber: '#${(b['id'] as String).substring(0, 8).toUpperCase()}',
      eventName: '', // not modelled server-side yet
      serviceName: listing?['title'] as String? ?? 'Listing',
      vendorName: '',
      clientName: client?['name'] as String? ?? 'Client',
      clientImage: null,
      thumbnailUrl: null,
      eventDate: DateTime.parse(b['eventDate'] as String),
      eventLocation:
          loc is Map ? (loc['address'] as String? ?? 'TBD') : 'TBD',
      eventVenue: loc is Map ? (loc['address'] as String? ?? 'TBD') : 'TBD',
      guestCount: 0,
      category: '',
      duration: '',
      additionalInfo: b['requirements'] as String?,
      clientRating: 0,
      accountNumber: '',
      bankName: '',
      amount: amount == null ? 0 : (double.tryParse(amount.toString()) ?? 0),
      // Backend statuses pass through UPPERCASE: PENDING | CONFIRMED |
      // COMPLETED | CANCELLED (UI chips/filters handle them).
      status: b['status'] as String? ?? 'PENDING',
      fulfilmentType: b['fulfilmentType'] as String?,
    );
  }

  TrackingOrderModel _toTracking(Map<String, dynamic> b) {
    final listing = b['listing'] as Map?;
    final client = b['client'] as Map?;
    final loc = b['eventLocation'];
    final fulfil = (b['fulfilmentType'] as String? ?? 'PURCHASE').toLowerCase();
    final isRental = fulfil == 'rental';
    final bStatus = (b['status'] as String? ?? 'PENDING').toUpperCase();
    final status = _trackStatus(bStatus, isRental);
    final created = _date(b['createdAt']) ?? DateTime.now();
    final updated = _date(b['updatedAt']);
    final delivery = (b['deliveryMethod'] as String?)?.toUpperCase();

    return TrackingOrderModel(
      id: b['id'] as String,
      orderNumber: '#${(b['id'] as String).substring(0, 8).toUpperCase()}',
      orderType: isRental ? 'rental' : 'purchase',
      productName: listing?['title'] as String? ?? 'Item',
      clientName: client?['name'] as String? ?? 'Client',
      orderDate: created,
      status: status,
      amount: _num(b['finalAmount'] ?? b['quoteAmount']),
      deliveryCost: _num(b['deliveryFee']),
      hasDelivery: delivery == 'DELIVERY',
      deliveryAddress:
          loc is Map ? loc['address'] as String? : null,
      depositAmount: _num(b['depositAmount']),
      pickupTime: _date(b['pickupAt']),
      returnByTime: _date(b['returnAt']),
      orderPlacedAt: created,
      // Best-effort timeline stamps from the coarse booking status.
      vendorConfirmedAt: bStatus == 'PENDING' ? null : updated,
      deliveredAt:
          (!isRental && bStatus == 'COMPLETED') ? updated : null,
      returnConfirmedAt:
          (isRental && bStatus == 'COMPLETED') ? updated : null,
    );
  }

  /// Map a coarse booking status onto the tracking lifecycle vocabulary.
  String _trackStatus(String bookingStatus, bool isRental) {
    switch (bookingStatus) {
      case 'CANCELLED':
        return 'cancelled';
      case 'COMPLETED':
        return isRental ? 'return_confirmed' : 'delivered';
      case 'PENDING':
        return 'requested';
      default: // CONFIRMED | ACTIVE
        return 'confirmed';
    }
  }

  double _num(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }

  DateTime? _date(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());
}
