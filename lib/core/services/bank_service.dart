import '../api/api_client.dart';
import '../api/api_utils.dart';
import '../../shared/models/bank_models.dart';

/// Vendor bank-account setup for the direct-pay flow (/vendor-bank).
class BankService {
  final ApiClient _api;
  BankService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<List<BankOption>> listBanks() async {
    final res = await _api.dio.get('/vendor-bank/banks');
    ensureOk(res);
    return (res.data as List? ?? const [])
        .map((e) => BankOption.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// Verify an account number → the registered account name.
  Future<String> resolve(String bankCode, String accountNumber) async {
    final res = await _api.dio.post('/vendor-bank/resolve', data: {
      'bankCode': bankCode,
      'accountNumber': accountNumber,
    });
    ensureOk(res);
    return (res.data as Map?)?['accountName'] as String? ?? '';
  }

  /// Save the account + create the 0%-cut Paystack subaccount.
  Future<BankAccount> save({
    required String bankCode,
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) async {
    final res = await _api.dio.post('/vendor-bank', data: {
      'bankCode': bankCode,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'accountName': accountName,
    });
    ensureOk(res);
    return BankAccount.fromJson(Map<String, dynamic>.from(res.data));
  }

  /// The vendor's saved account, or null if none set up.
  Future<BankAccount?> getMine() async {
    final res = await _api.dio.get('/vendor-bank');
    ensureOk(res);
    if (res.data == null) return null;
    return BankAccount.fromJson(Map<String, dynamic>.from(res.data));
  }
}
