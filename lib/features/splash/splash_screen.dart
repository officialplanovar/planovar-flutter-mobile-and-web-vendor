import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/router/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go(AppRoutes.onboarding);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  'P',
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'PLANOVAR',
              style: GoogleFonts.urbanist(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'VENDOR',
              style: GoogleFonts.urbanist(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
