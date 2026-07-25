import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';

/// Thin wrapper over the Better Auth endpoints (/api/auth/*).
/// Captures the `set-auth-token` header (bearer plugin) into secure storage.
class AuthRemoteDataSource {
  final ApiClient _api;
  AuthRemoteDataSource(this._api);

  Dio get _dio => _api.dio;

  Future<Map<String, dynamic>> signUpEmail({
    required String name,
    required String email,
    required String password,
    String role = 'VENDOR',
    String? phone,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
  }) async {
    final res = await _dio.post('/api/auth/sign-up/email', data: {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (firstName != null && firstName.isNotEmpty) 'firstName': firstName,
      if (lastName != null && lastName.isNotEmpty) 'lastName': lastName,
      if (dateOfBirth != null && dateOfBirth.isNotEmpty)
        'dateOfBirth': dateOfBirth,
    });
    _ensureOk(res);
    await _captureToken(res);
    return _asMap(res.data);
  }

  Future<Map<String, dynamic>> signInEmail({
    required String email,
    required String password,
  }) async {
    final res = await _dio
        .post('/api/auth/sign-in/email', data: {'email': email, 'password': password});
    _ensureOk(res);
    await _captureTokenOrThrow(res);
    return _asMap(res.data);
  }

  Future<Map<String, dynamic>?> getSession() async {
    final res = await _dio.get('/api/auth/get-session');
    if (res.statusCode == 200 && res.data is Map) return _asMap(res.data);
    return null;
  }

  Future<void> sendOtp({required String email, String type = 'email-verification'}) async {
    final res = await _dio.post('/api/auth/email-otp/send-verification-otp',
        data: {'email': email, 'type': type});
    _ensureOk(res);
  }

  Future<Map<String, dynamic>> verifyEmailOtp({
    required String email,
    required String otp,
  }) async {
    final res = await _dio
        .post('/api/auth/email-otp/verify-email', data: {'email': email, 'otp': otp});
    _ensureOk(res);
    await _captureTokenOrThrow(res);
    return _asMap(res.data);
  }

  Future<void> resetPasswordOtp({
    required String email,
    required String otp,
    required String password,
  }) async {
    final res = await _dio.post('/api/auth/email-otp/reset-password',
        data: {'email': email, 'otp': otp, 'password': password});
    _ensureOk(res);
  }

  Future<void> signOut() async {
    try {
      await _dio.post('/api/auth/sign-out');
    } catch (_) {
      // ignore — clear the local token regardless
    }
    await _api.tokenStore.clear();
  }

  /// Update the account/user record (phone, dateOfBirth, name, …) via PATCH /users/me.
  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> data) async {
    final res = await _dio.patch('/users/me', data: data);
    _ensureOk(res);
    return _asMap(res.data);
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  /// Saves the bearer token from the `set-auth-token` header if present.
  /// Returns true when a token was captured. Best-effort (never throws) — used
  /// on sign-up, where the session is established later at OTP verification.
  Future<bool> _captureToken(Response res) async {
    final token = res.headers.value('set-auth-token');
    if (token != null && token.isNotEmpty) {
      await _api.tokenStore.save(token);
      return true;
    }
    return false;
  }

  /// Like [_captureToken] but REQUIRES a token — the app authenticates purely by
  /// bearer token, so a sign-in/verify that yields no token leaves every
  /// subsequent request unauthenticated ("Unauthorised" everywhere). This most
  /// often means the `set-auth-token` response header wasn't readable (a web
  /// CORS `Access-Control-Expose-Headers` / trusted-origin misconfiguration).
  /// Failing loudly here beats a silent "logged-in but tokenless" session.
  Future<void> _captureTokenOrThrow(Response res) async {
    if (await _captureToken(res)) return;
    await _api.tokenStore.clear();
    throw Exception(
      "Signed in, but we couldn't establish a secure session. "
      'Please try again, and if it persists contact support.',
    );
  }

  Map<String, dynamic> _asMap(dynamic data) =>
      data is Map<String, dynamic> ? data : <String, dynamic>{};

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
