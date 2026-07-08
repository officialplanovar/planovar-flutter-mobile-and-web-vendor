import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/router/app_routes.dart';
import '../../core/widgets/planovar_logo.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          _go(AppRoutes.home);
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
