import '../../../core/api/api_client.dart';
import '../../../core/api/api_utils.dart';
import '../../../shared/models/order_model.dart';

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

  Future<void> complete(String id) async =>
      ensureOk(await _api.dio.post('/bookings/$id/complete'));

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
    );
  }
}
