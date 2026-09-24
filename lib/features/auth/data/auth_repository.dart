import '../../../core/api/api_client.dart';
import '../../../shared/models/user_model.dart';
import 'auth_remote_data_source.dart';

/// Result of a sign-in attempt: either an authenticated user, or a 2FA challenge
/// that must be completed with a TOTP code before a session is issued.
class SignInResult {
  final UserModel? user;
  final bool twoFactorRequired;
  const SignInResult({this.user, this.twoFactorRequired = false});
}

/// Real auth backed by the Planovar API. Mirrors the old MockAuthService method
/// shapes so AuthBloc can use it as a drop-in replacement.
class AuthRepository {
  final AuthRemoteDataSource _remote;

  AuthRepository({AuthRemoteDataSource? remote})
      : _remote = remote ?? AuthRemoteDataSource(ApiClient());

  Future<SignInResult> signIn({required String email, required String password}) async {
    final data = await _remote.signInEmail(email: email, password: password);
    if (data['twoFactorRedirect'] == true) {
      return const SignInResult(twoFactorRequired: true);
    }
    return SignInResult(user: UserModel.fromJson(_extractUser(data)));
  }

  // ── Two-factor auth (TOTP) ─────────────────────────────────────────────────
  Future<Map<String, dynamic>> enableTwoFactor(String password) =>
      _remote.enableTwoFactor(password);

  Future<void> disableTwoFactor(String password) =>
      _remote.disableTwoFactor(password);

  /// Verify a TOTP code (finishes enabling, or the sign-in challenge).
  Future<void> verifyTotp(String code) => _remote.verifyTotp(code);

  Future<bool> isTwoFactorEnabled() => _remote.isTwoFactorEnabled();

  /// Complete a 2FA sign-in challenge: verify the code, then load the user.
  Future<UserModel> completeTwoFactorSignIn(String code) async {
    await _remote.verifyTotp(code);
    return getMe();
  }

  /// Launches the Google OAuth flow (redirects the browser to Google).
  Future<void> signInWithGoogle() => _remote.signInWithGoogle();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _remote.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

  Future<void> deleteAccount() => _remote.deleteAccount();

  Future<void> deactivateAccount() => _remote.deactivateAccount();

  Future<Map<String, dynamic>> getNotificationPrefs() =>
      _remote.getNotificationPrefs();

  Future<void> updateNotificationPrefs(Map<String, dynamic> prefs) =>
      _remote.updateNotificationPrefs(prefs);

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
    // /users/me carries role + vendorProfile + clientProfile for role gating;
    // fall back to the session endpoint if it's unavailable.
    final me = await _remote.me() ?? await _remote.getSession();
    if (me == null) throw Exception('No active session');
    return UserModel.fromJson(_extractUser(me));
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
