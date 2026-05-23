import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/app_button.dart';

class _OnboardingSlide {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

const _slides = [
  _OnboardingSlide(
    icon: Icons.storefront_rounded,
    title: 'Unlock thousands of event clients',
    subtitle:
        'Connect with couples, corporates, and event planners in your location, all actively searching for vendors like you',
  ),
  _OnboardingSlide(
    icon: Icons.dashboard_rounded,
    title: 'Manage Everything in one Dashboard',
    subtitle:
        'Track orders, messages, and payouts from a single workspace',
  ),
  _OnboardingSlide(
    icon: Icons.payments_rounded,
    title: 'Get paid automatically',
    subtitle:
        'Payouts hit your account within 24–48 hours of order completion. No manual follow-up needed.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top row with skip button
            SizedBox(
              height: 52,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo area
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Center(
                            child: Text(
                              'P',
                              style: GoogleFonts.urbanist(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Planovar',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    if (!isLastPage)
                      TextButton(
                        onPressed: () => context.go(AppRoutes.register),
                        child: Text(
                          'Skip',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            slide.icon,
                            color: AppColors.primary,
                            size: 56,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dots indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _slides.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: AppColors.primary,
                  dotColor: AppColors.primaryLight,
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                  spacing: 6,
                ),
              ),
            ),

            // CTA area
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: isLastPage
                  ? Column(
                      children: [
                        AppButton.primary(
                          'List my business',
                          onTap: () => context.go(AppRoutes.register),
                        ),
                        const SizedBox(height: 12),
                        AppButton.secondary(
                          'I already have an account',
                          onTap: () => context.go(AppRoutes.login),
                        ),
                      ],
                    )
                  : AppButton.primary(
                      'Next',
                      onTap: _nextPage,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
