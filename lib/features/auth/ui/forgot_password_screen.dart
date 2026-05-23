import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _sent = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (_emailCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _loading = false;
        _sent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Forgot Password',
          style: GoogleFonts.urbanist(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
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
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter your email address and we'll send you a link to reset your password.",
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: AppColors.textSecondary,
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
                        'A reset link has been sent to ${_emailCtrl.text.trim()}. Check your inbox.',
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

            AppButton.primary(
              _sent ? 'Resend Link' : 'Send Reset Link',
              loading: _loading,
              onTap: _loading ? null : _sendResetLink,
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
