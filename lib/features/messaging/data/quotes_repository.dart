import '../../../core/api/api_client.dart';
import '../../../core/api/api_utils.dart';

class QuoteLineItemInput {
  final String label;
  final double amount;
  const QuoteLineItemInput({required this.label, required this.amount});
}

class QuotesRepository {
  final ApiClient _api;
  QuotesRepository({ApiClient? api}) : _api = api ?? ApiClient();

  /// Sends a price proposal on a booking inquiry. Payment terms are
  /// informational (off-platform) — structure stays FULL_UPFRONT server-side.
  Future<Map<String, dynamic>> create({
    required String bookingId,
    required List<QuoteLineItemInput> lineItems,
    required DateTime validUntil,
    String? notes,
    String? description,
  }) async {
    final total =
        lineItems.fold<double>(0, (sum, item) => sum + item.amount);
    final res = await _api.dio.post('/quotes', data: {
      'bookingId': bookingId,
      'totalAmount': total,
      'validUntil': validUntil.toUtc().toIso8601String(),
      'paymentStructure': 'FULL_UPFRONT',
      if (notes != null && notes.isNotEmpty) 'notes': notes,
      if (description != null && description.isNotEmpty)
        'description': description,
      'lineItems': [
        for (var i = 0; i < lineItems.length; i++)
          {
            'label': lineItems[i].label,
            'amount': lineItems[i].amount,
            'sortOrder': i,
          },
      ],
    });
    ensureOk(res);
    return Map<String, dynamic>.from(res.data as Map);
  }
}
