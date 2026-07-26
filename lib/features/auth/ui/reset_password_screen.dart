import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Enter the emailed OTP + a new password. The OTP is validated by the
/// reset-password call itself (Better Auth emailOTP), so no separate verify
/// step is needed for the reset branch.
class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _otpCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure1 = true;
  bool _obscure2 = true;

  bool get _otpValid => _otpCtrl.text.trim().length == 6;
  bool get _lengthOk => _passwordCtrl.text.length >= 8;
  bool get _match =>
      _passwordCtrl.text == _confirmCtrl.text && _confirmCtrl.text.isNotEmpty;
  bool get _canSubmit => _otpValid && _lengthOk && _match;

  @override
  void dispose() {
    _otpCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_canSubmit) return;
    context.read<AuthBloc>().add(AuthResetPasswordRequested(
          email: widget.email,
          otp: _otpCtrl.text.trim(),
          newPassword: _passwordCtrl.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.surface,
      appBar: AppBar(
        backgroundColor: context.c.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: context.c.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Reset Password',
          style: GoogleFonts.urbanist(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: context.c.textPrimary,
          ),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Password reset successfully. Please sign in.')),
            );
            context.go(AppRoutes.login);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: pagePadding(context, base: 24).add(const EdgeInsets.only(top: 16, bottom: 40)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: context.c.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_reset_rounded,
                    color: AppColors.primary, size: 36),
              ),
              const SizedBox(height: 20),
              Text(
                'Create a new password',
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: context.c.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: 'Enter the 6-digit code sent to ',
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    color: context.c.textSecondary,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: widget.email,
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: ' and choose a new password.'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              AppInput(
                label: 'Verification Code',
                hint: '6-digit code',
                controller: _otpCtrl,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              AppInput(
                label: 'New Password',
                hint: 'At least 8 characters',
                controller: _passwordCtrl,
                obscureText: _obscure1,
                onChanged: (_) => setState(() {}),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure1
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: context.c.textHint,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                ),
                errorText: _passwordCtrl.text.isNotEmpty && !_lengthOk
                    ? 'Must be at least 8 characters'
                    : null,
              ),
              const SizedBox(height: 12),
              AppInput(
                label: 'Confirm Password',
                hint: 'Re-enter your new password',
                controller: _confirmCtrl,
                obscureText: _obscure2,
                textInputAction: TextInputAction.done,
                onChanged: (_) => setState(() {}),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure2
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: context.c.textHint,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                ),
                errorText: _confirmCtrl.text.isNotEmpty && !_match
                    ? 'Passwords do not match'
                    : null,
              ),
              const SizedBox(height: 28),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final loading = state is AuthLoading;
                  return AppButton.primary(
                    'Reset Password',
                    loading: loading,
                    onTap: (_canSubmit && !loading) ? _submit : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
