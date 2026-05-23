import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    setState(() => _loading = true);
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vendor_isLoggedIn', true);
    if (mounted) {
      setState(() => _loading = false);
      context.go(AppRoutes.home);
    }
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: AppColors.textHint,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Center(
                child: Text(
                  'G',
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4285F4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Continue with Google',
              style: GoogleFonts.urbanist(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
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
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Sign in to your vendor account',
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: AppColors.textSecondary,
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
                  color: AppColors.textHint,
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
            AppButton.primary(
              'Sign In',
              loading: _loading,
              onTap: _loading ? null : _signIn,
            ),
            const SizedBox(height: 20),

            _buildDivider(),
            const SizedBox(height: 20),

            _buildGoogleButton(),
            const SizedBox(height: 32),

            // Register link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: AppColors.textSecondary,
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
