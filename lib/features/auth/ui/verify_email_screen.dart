import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/app_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  String _otp = '';
  int _countdown = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdown = 45;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown == 0) {
        t.cancel();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = _otp.length == 6;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon in circle
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_rounded,
                color: AppColors.primary,
                size: 44,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Verify your Email',
              style: GoogleFonts.urbanist(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "We've sent a 6-digit OTP to your email",
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Highlighted email box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.email.isNotEmpty ? widget.email : 'your@email.com',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // OTP input
            PinCodeTextField(
              appContext: context,
              length: 6,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12),
                fieldHeight: 52,
                fieldWidth: 44,
                activeFillColor: AppColors.primaryLight,
                selectedFillColor: AppColors.primaryLight,
                inactiveFillColor: AppColors.divider,
                activeColor: AppColors.primary,
                selectedColor: AppColors.primary,
                inactiveColor: Colors.transparent,
              ),
              enableActiveFill: true,
              onChanged: (v) => setState(() => _otp = v),
              textStyle: GoogleFonts.urbanist(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 32),

            // Proceed button
            AppButton.primary(
              'Proceed',
              onTap: canProceed
                  ? () => context.go(AppRoutes.setupBusinessType)
                  : null,
            ),
            const SizedBox(height: 24),

            // Resend
            if (_countdown > 0)
              Text(
                'Resend code in ${_countdown}s',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              )
            else
              GestureDetector(
                onTap: _startCountdown,
                child: Text(
                  'Resend code',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
