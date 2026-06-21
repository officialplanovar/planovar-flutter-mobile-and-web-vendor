import 'package:dio/dio.dart';
import '../api/api_client.dart';
import '../api/api_utils.dart';

/// Uploads files to the API's `/upload/*` endpoints and returns the hosted URL.
/// Sends bytes (works on web and mobile alike).
class UploadService {
  final ApiClient _api;

  UploadService({ApiClient? api}) : _api = api ?? ApiClient();

  Future<String> _post(
    String path, {
    required List<int> bytes,
    required String filename,
  }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(bytes, filename: filename),
    });
    final res = await _api.dio.post(path, data: form);
    ensureOk(res);
    final url = (res.data as Map)['url'] as String?;
    if (url == null || url.isEmpty) {
      throw Exception('Upload succeeded but no URL was returned');
    }
    return url;
  }

  /// Square business logo (image only).
  Future<String> uploadVendorLogo(List<int> bytes, String filename) =>
      _post('/upload/vendor/logo', bytes: bytes, filename: filename);

  /// Listing photo (image only).
  Future<String> uploadListingImage(List<int> bytes, String filename) =>
      _post('/upload/listing/image', bytes: bytes, filename: filename);

  /// Document (image or PDF) — used for proof of ownership.
  Future<String> uploadDocument(List<int> bytes, String filename) =>
      _post('/upload/attachment', bytes: bytes, filename: filename);
}
