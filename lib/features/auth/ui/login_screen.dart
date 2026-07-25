import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../data/auth_repository.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: context.c.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: context.c.textHint,
            ),
          ),
        ),
        Expanded(child: Divider(color: context.c.border)),
      ],
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
      onTap: () => _googleSignIn(context),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.c.border, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/google_logo.svg',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: GoogleFonts.urbanist(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.c.textPrimary,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<void> _googleSignIn(BuildContext context) async {
    try {
      await AuthRepository().signInWithGoogle();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back',
              style: GoogleFonts.urbanist(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Sign in to your vendor account',
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: context.c.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Email
            AppInput(
              label: 'Email Address',
              hint: 'yourname@business.com',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password
            AppInput(
              label: 'Password',
              hint: 'Enter your password',
              controller: _passwordCtrl,
              obscureText: _obscure,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: context.c.textHint,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            const SizedBox(height: 10),

            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.forgotPassword),
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Sign in button
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  context.go(AppRoutes.home);
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                final loading = state is AuthLoading;
                return AppButton.primary(
                  'Sign In',
                  loading: loading,
                  onTap: loading
                      ? null
                      : () => context.read<AuthBloc>().add(
                            AuthSignInRequested(
                              email: _emailCtrl.text.trim(),
                              password: _passwordCtrl.text,
                            ),
                          ),
                );
              },
            ),
            const SizedBox(height: 20),

            _buildDivider(context),
            const SizedBox(height: 20),

            _buildGoogleButton(context),
            const SizedBox(height: 32),

            // Register link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: context.c.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.register),
                  child: Text(
                    'Register',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
