import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../shared/models/vendor_model.dart';

class VendorRepository {
  final ApiClient _api;
  VendorRepository({ApiClient? api}) : _api = api ?? ApiClient();

  /// Creates the vendor profile (elevates the user's role to VENDOR server-side).
  Future<VendorModel> onboard({
    required String businessName,
    required String slug,
    String? businessType, // LICENSED | FREELANCER
    String? vendorType, // PRODUCTS | SERVICES | BOTH
    String? description,
    String? logoUrl,
    Map<String, dynamic>? location,
    int? serviceRadiusKm,
    List<String>? tags,
    List<String>? eventTypes,
  }) async {
    final res = await _api.dio.post('/vendors/onboard', data: {
      'businessName': businessName,
      'slug': slug,
      if (businessType != null) 'businessType': businessType,
      if (vendorType != null) 'vendorType': vendorType,
      if (description != null) 'description': description,
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (location != null) 'location': location,
      if (serviceRadiusKm != null) 'serviceRadiusKm': serviceRadiusKm,
      if (tags != null) 'tags': tags,
      if (eventTypes != null) 'eventTypes': eventTypes,
    });
    _ensureOk(res);
    return VendorModel.fromJson(Map<String, dynamic>.from(res.data as Map));
  }

  Future<VendorModel?> getMe() async {
    final res = await _api.dio.get('/vendors/me');
    if (res.statusCode == 200 && res.data is Map) {
      return VendorModel.fromJson(Map<String, dynamic>.from(res.data));
    }
    return null;
  }

  /// Types the freshly-created account as a vendor (called right after a
  /// vendor-app sign-up) so the app's role gate admits them. The backend
  /// refuses established client accounts.
  Future<void> claimIntent() async {
    await _api.dio.post('/vendors/intent');
  }

  /// Updates the current vendor profile (PATCH /vendors/me).
  Future<VendorModel> updateProfile(Map<String, dynamic> changes) async {
    final res = await _api.dio.patch('/vendors/me', data: changes);
    _ensureOk(res);
    return VendorModel.fromJson(Map<String, dynamic>.from(res.data as Map));
  }

  /// Submits KYC/KYB documents: a government ID for every vendor, plus a
  /// business registration document for registered (LICENSED) businesses.
  Future<Map<String, dynamic>> submitKyc({
    required String idDocumentUrl,
    required String idType,
    required String idCountry,
    String? businessRegDocumentUrl,
    String? businessRegCountry,
  }) async {
    final res = await _api.dio.post('/vendors/me/kyc', data: {
      'idDocumentUrl': idDocumentUrl,
      'idType': idType,
      'idCountry': idCountry,
      if (businessRegDocumentUrl != null)
        'businessRegDocumentUrl': businessRegDocumentUrl,
      if (businessRegCountry != null) 'businessRegCountry': businessRegCountry,
    });
    _ensureOk(res);
    return Map<String, dynamic>.from(res.data as Map);
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
