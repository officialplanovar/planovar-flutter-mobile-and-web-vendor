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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
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
          'Forgot Password',
          style: GoogleFonts.urbanist(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: context.c.textPrimary,
          ),
        ),
      ),
      body: Padding(
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
              child: const Icon(
                Icons.lock_reset_rounded,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Reset your password',
              style: GoogleFonts.urbanist(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter your email address and we'll send you a 6-digit code to reset your password.",
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: context.c.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            AppInput(
              label: 'Email Address',
              hint: 'yourname@business.com',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              enabled: !_sent,
            ),
            const SizedBox(height: 12),

            // Success message shown inline
            if (_sent) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.activeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.activeText,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'A reset code has been sent to ${_emailCtrl.text.trim()}. Check your inbox.',
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          color: AppColors.activeText,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            const SizedBox(height: 16),

            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthPasswordResetSent) {
                  setState(() => _sent = true);
                  context.push(AppRoutes.resetPassword,
                      extra: {'email': _emailCtrl.text.trim()});
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                final loading = state is AuthLoading;
                return AppButton.primary(
                  _sent ? 'Resend Code' : 'Send Reset Code',
                  loading: loading,
                  onTap: loading
                      ? null
                      : () {
                          final email = _emailCtrl.text.trim();
                          if (email.isEmpty) return;
                          context
                              .read<AuthBloc>()
                              .add(AuthForgotPasswordRequested(email: email));
                        },
                );
              },
            ),

            if (_sent) ...[
              const SizedBox(height: 16),
              AppButton.secondary(
                'Back to Sign In',
                onTap: () => context.pop(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
