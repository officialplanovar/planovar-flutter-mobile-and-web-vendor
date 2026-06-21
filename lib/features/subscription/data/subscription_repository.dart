import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../shared/models/subscription_plan_model.dart';

class SubscriptionRepository {
  final ApiClient _api;
  SubscriptionRepository({ApiClient? api}) : _api = api ?? ApiClient();

  Future<List<SubscriptionPlanModel>> listPlans() async {
    final res = await _api.dio.get('/subscriptions/plans');
    _ensureOk(res);
    final list = res.data as List? ?? const [];
    return list
        .map((e) => SubscriptionPlanModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Returns the vendor's active subscription, or null if they have none (404).
  Future<Map<String, dynamic>?> getMySubscription() async {
    final res = await _api.dio.get('/subscriptions/me');
    if (res.statusCode == 200 && res.data is Map) {
      return Map<String, dynamic>.from(res.data);
    }
    return null;
  }

  /// Basic → activates immediately; Premium/Gold → returns `checkoutUrl`
  /// (payment required; the plan activates only after `verify`).
  Future<Map<String, dynamic>> subscribe({
    required String planId,
    String billingCycle = 'MONTHLY',
    String? deviceId,
    String? callbackUrl,
  }) async {
    final res = await _api.dio.post(
      '/subscriptions/subscribe',
      data: {
        'planId': planId,
        'billingCycle': billingCycle,
        if (callbackUrl != null) 'callbackUrl': callbackUrl,
      },
      options: deviceId != null
          ? Options(headers: {'x-device-id': deviceId})
          : null,
    );
    _ensureOk(res);
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// Switch/upgrade to another plan (ends the current one first). Same response
  /// shape as [subscribe] — Premium/Gold return a `checkoutUrl`.
  Future<Map<String, dynamic>> changePlan({
    required String planId,
    String billingCycle = 'MONTHLY',
    String? deviceId,
    String? callbackUrl,
  }) async {
    final res = await _api.dio.post(
      '/subscriptions/change',
      data: {
        'planId': planId,
        'billingCycle': billingCycle,
        if (callbackUrl != null) 'callbackUrl': callbackUrl,
      },
      options: deviceId != null
          ? Options(headers: {'x-device-id': deviceId})
          : null,
    );
    _ensureOk(res);
    return Map<String, dynamic>.from(res.data as Map);
  }

  /// Confirms a paid plan's payment by Paystack reference; activates it on success.
  Future<Map<String, dynamic>> verify(String reference) async {
    final res = await _api.dio.post('/subscriptions/verify', data: {'reference': reference});
    _ensureOk(res);
    return Map<String, dynamic>.from(res.data as Map);
  }

  Future<void> cancel() async {
    final res = await _api.dio.post('/subscriptions/cancel');
    _ensureOk(res);
  }

  void _ensureOk(Response res) {
    final code = res.statusCode ?? 0;
    if (code >= 200 && code < 300) return;
    final data = res.data;
    final msg = (data is Map && data['message'] != null)
        ? data['message'].toString()
        : 'Request failed ($code)';
    throw Exception(msg);
  }
}
