import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

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
      backgroundColor: context.c.surface,
      appBar: AppBar(
        backgroundColor: context.c.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: context.c.textPrimary,
          ),
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
              decoration: BoxDecoration(
                color: context.c.primaryLight,
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
                color: context.c.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "We've sent a 6-digit OTP to your email",
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: context.c.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Highlighted email box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: context.c.primaryLight,
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

            // OTP input — constrained so the fixed-width boxes don't stretch on web.
            // Theme override: PinCodeTextField renders a hidden TextField under the
            // boxes which inherits the app-wide filled/grey InputDecorationTheme —
            // that painted a grey bar behind the row. Strip the fill locally.
            Center(
              child: SizedBox(
                width: 320,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                      filled: false,
                      border: InputBorder.none,
                    ),
                  ),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    keyboardType: TextInputType.number,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(12),
                      fieldHeight: 56,
                      fieldWidth: 48,
                      borderWidth: 1.5,
                      activeFillColor: context.c.surface,
                      selectedFillColor: context.c.surface,
                      inactiveFillColor: context.c.surface,
                      // visible outline on empty boxes (divider #F3F4F6 is too faint)
                      inactiveColor: context.c.border,
                      selectedColor: AppColors.primary,
                      activeColor: AppColors.primary,
                    ),
                    enableActiveFill: true,
                    onChanged: (v) => setState(() => _otp = v),
                    textStyle: GoogleFonts.urbanist(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Proceed button — verifies the OTP against the backend
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthOtpVerified) {
                  context.go(AppRoutes.setupBusinessType);
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final loading = state is AuthLoading;
                return AppButton.primary(
                  'Proceed',
                  loading: loading,
                  onTap: (canProceed && !loading)
                      ? () => context.read<AuthBloc>().add(
                          AuthOtpVerifyRequested(
                            email: widget.email,
                            otp: _otp,
                          ),
                        )
                      : null,
                );
              },
            ),
            const SizedBox(height: 24),

            // Resend
            if (_countdown > 0)
              Text(
                'Resend code in ${_countdown}s',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: context.c.textSecondary,
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
