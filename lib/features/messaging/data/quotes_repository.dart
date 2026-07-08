import '../../../core/api/api_client.dart';
import '../../../core/api/api_utils.dart';

class QuoteLineItemInput {
  final String label;
  final double amount;
  const QuoteLineItemInput({required this.label, required this.amount});
}

class QuotePaymentTermInput {
  final String label;
  final double percentage;
  final String? dueLabel;
  const QuotePaymentTermInput({
    required this.label,
    required this.percentage,
    this.dueLabel,
  });
}

class QuotesRepository {
  final ApiClient _api;
  QuotesRepository({ApiClient? api}) : _api = api ?? ApiClient();

  /// Sends a chat quote (v1) to a client for a listing — the direct-pay flow.
  /// The quote appears as a card in the DM and, on accept, becomes an invoice.
  Future<void> sendQuote({
    required String clientId,
    required String listingId,
    String? eventId,
    required List<QuoteLineItemInput> lineItems,
    List<QuotePaymentTermInput> paymentTerms = const [],
    int validForDays = 7,
    String? description,
    String? notes,
  }) async {
    final res = await _api.dio.post('/chat-orders/quotes', data: {
      'clientId': clientId,
      'listingId': listingId,
      if (eventId != null) 'eventId': eventId,
      'lineItems': [
        for (final li in lineItems) {'label': li.label, 'amount': li.amount},
      ],
      if (paymentTerms.isNotEmpty)
        'paymentTerms': [
          for (final t in paymentTerms)
            {
              'label': t.label,
              'percentage': t.percentage,
              if (t.dueLabel != null) 'dueLabel': t.dueLabel,
            },
        ],
      'validForDays': validForDays,
      if (description != null && description.isNotEmpty)
        'description': description,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    });
    ensureOk(res);
  }

  /// Ticks/unticks the vendor's own task on a group-chat to-do.
  Future<void> toggleTodo(String todoId) async {
    final res = await _api.dio.post('/chat-orders/todos/$todoId/toggle');
    ensureOk(res);
  }

  /// Revises the active quote — supersedes it with a new version.
  Future<void> reviseQuote({
    required String quoteId,
    required List<QuoteLineItemInput> lineItems,
    List<QuotePaymentTermInput> paymentTerms = const [],
    DateTime? validUntil,
    String? description,
    String? notes,
  }) async {
    final res = await _api.dio.post('/chat-orders/quotes/$quoteId/revise', data: {
      'lineItems': [
        for (final li in lineItems) {'label': li.label, 'amount': li.amount},
      ],
      if (paymentTerms.isNotEmpty)
        'paymentTerms': [
          for (final t in paymentTerms)
            {
              'label': t.label,
              'percentage': t.percentage,
              if (t.dueLabel != null) 'dueLabel': t.dueLabel,
            },
        ],
      if (validUntil != null) 'validUntil': validUntil.toUtc().toIso8601String(),
      if (description != null && description.isNotEmpty)
        'description': description,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    });
    ensureOk(res);
  }

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
