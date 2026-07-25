import '../../../core/api/api_client.dart';
import '../../../shared/models/user_model.dart';
import 'auth_remote_data_source.dart';

/// Real auth backed by the Planovar API. Mirrors the old MockAuthService method
/// shapes so AuthBloc can use it as a drop-in replacement.
class AuthRepository {
  final AuthRemoteDataSource _remote;

  AuthRepository({AuthRemoteDataSource? remote})
      : _remote = remote ?? AuthRemoteDataSource(ApiClient());

  Future<UserModel> signIn({required String email, required String password}) async {
    final data = await _remote.signInEmail(email: email, password: password);
    return UserModel.fromJson(_extractUser(data));
  }

  /// Launches the Google OAuth flow (redirects the browser to Google).
  Future<void> signInWithGoogle() => _remote.signInWithGoogle();

  Future<UserModel> signUp({
    required String firstName,
    required String lastName,
    String? dateOfBirth,
    required String businessName,
    required String email,
    required String password,
    String? phone,
  }) async {
    final fullName = [firstName.trim(), lastName.trim()]
        .where((s) => s.isNotEmpty)
        .join(' ');
    final data = await _remote.signUpEmail(
      // The account's display name is the contact person; the business name is
      // stored separately on the vendor profile at onboarding.
      name: fullName.isNotEmpty ? fullName : businessName,
      firstName: firstName.trim().isEmpty ? null : firstName.trim(),
      lastName: lastName.trim().isEmpty ? null : lastName.trim(),
      dateOfBirth: dateOfBirth,
      email: email,
      password: password,
      phone: phone,
    );
    // Fire the email-verification OTP (best-effort; verify screen follows).
    try {
      await _remote.sendOtp(email: email, type: 'email-verification');
    } catch (_) {}
    return UserModel.fromJson(_extractUser(data));
  }

  Future<bool> verifyOtp({required String email, required String otp}) async {
    await _remote.verifyEmailOtp(email: email, otp: otp);
    return true;
  }

  Future<bool> forgotPassword({required String email}) async {
    await _remote.sendOtp(email: email, type: 'forget-password');
    return true;
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await _remote.resetPasswordOtp(email: email, otp: otp, password: newPassword);
    return true;
  }

  Future<UserModel> getMe() async {
    final session = await _remote.getSession();
    if (session == null) throw Exception('No active session');
    return UserModel.fromJson(_extractUser(session));
  }

  Future<void> signOut() => _remote.signOut();

  /// PATCH /users/me — update account fields (phone, dateOfBirth, name, …).
  Future<UserModel> updateMe(Map<String, dynamic> data) async {
    final res = await _remote.updateUser(data);
    return UserModel.fromJson(_extractUser(res));
  }

  /// Better Auth returns `{ user: {...}, session: {...} }` (or a bare user).
  Map<String, dynamic> _extractUser(Map<String, dynamic> data) {
    final raw = data['user'] ?? data;
    final m = raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};
    m['id'] ??= (m['userId'] ?? '').toString();
    m['email'] ??= '';
    m['name'] ??= m['email'];
    m['role'] ??= 'VENDOR';
    return m;
  }
}
