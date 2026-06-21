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

  /// Updates the current vendor profile (PATCH /vendors/me).
  Future<VendorModel> updateProfile(Map<String, dynamic> changes) async {
    final res = await _api.dio.patch('/vendors/me', data: changes);
    _ensureOk(res);
    return VendorModel.fromJson(Map<String, dynamic>.from(res.data as Map));
  }

  /// Submits KYC documents (NIN always; CAC required for licensed businesses).
  Future<Map<String, dynamic>> submitKyc({
    required String ninDocumentUrl,
    String? cacDocumentUrl,
  }) async {
    final res = await _api.dio.post('/vendors/me/kyc', data: {
      'ninDocumentUrl': ninDocumentUrl,
      if (cacDocumentUrl != null) 'cacDocumentUrl': cacDocumentUrl,
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
