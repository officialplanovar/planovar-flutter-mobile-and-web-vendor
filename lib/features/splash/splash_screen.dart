import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/router/app_routes.dart';
import '../../core/widgets/planovar_logo.dart';
import '../../shared/models/user_model.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import '../auth/data/auth_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    // Restore the persisted session (if any), then route on the result.
    context.read<AuthBloc>().add(const AuthCheckRequested());
  }

  void _go(String route) {
    if (_navigated || !mounted) return;
    _navigated = true;
    context.go(route);
  }

  Future<void> _gateVendor(UserModel user) async {
    // This is the vendor app — it requires a vendor account. New vendor-app
    // sign-ups are typed VENDOR at creation (Google via the OAuth relay, email
    // via /vendors/intent), so any CLIENT reaching here is a client account
    // that belongs in the client app.
    if (user.role != 'VENDOR') {
      await AuthRepository().signOut();
      if (!mounted) return;
      await _showWrongAppDialog(
        'This account is registered as a client. Please use the Planovar '
        'client app to sign in.',
      );
      _go(AppRoutes.onboarding);
      return;
    }
    // Vendor with a profile → home; otherwise resume/begin setup (a fresh
    // sign-up has no business profile, subscription or KYC yet).
    _go(user.hasVendorProfile ? AppRoutes.home : AppRoutes.setupBusinessType);
  }

  Future<void> _showWrongAppDialog(String message) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Wrong app'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          _gateVendor(state.user);
        } else if (state is AuthUnauthenticated) {
          _go(AppRoutes.onboarding);
        }
      },
      child: Scaffold(
        backgroundColor: context.c.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlanovarLogo(dark: context.isDark, width: 260),
            const SizedBox(height: 4),
            Text(
              'VENDOR',
              style: GoogleFonts.urbanist(
                color: context.c.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 6,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
