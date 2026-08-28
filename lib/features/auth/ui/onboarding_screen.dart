import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/widgets/planovar_logo.dart';
import '../../../shared/widgets/app_button.dart';

class _OnboardingSlide {
  final String image; // asset hero illustration
  final IconData fallbackIcon; // shown if the asset is missing
  final String title;
  final String subtitle;

  const _OnboardingSlide({
    required this.image,
    required this.fallbackIcon,
    required this.title,
    required this.subtitle,
  });
}

const _slides = [
  _OnboardingSlide(
    image: 'assets/images/onboarding/onboarding_1.png',
    fallbackIcon: Icons.storefront_rounded,
    title: 'Unlock thousands of event clients',
    subtitle:
        'Connect with couples, corporates, and event planners in your location, all actively searching for vendors like you',
  ),
  _OnboardingSlide(
    image: 'assets/images/onboarding/onboarding_2.png',
    fallbackIcon: Icons.dashboard_rounded,
    title: 'Manage Everything in one Dashboard',
    subtitle:
        'Track your inquiries, bookings, and conversations from a single workspace',
  ),
  _OnboardingSlide(
    image: 'assets/images/onboarding/onboarding_3.png',
    fallbackIcon: Icons.workspace_premium_rounded,
    title: 'Showcase your work, get discovered',
    subtitle:
        'List your products, services and rentals — then subscribe to climb search rankings and reach event planners first.',
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
      backgroundColor: context.c.surface,
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
                    // Logo — larger on desktop.
                    PlanovarLogo(
                        height: MediaQuery.sizeOf(context).width >= 900
                            ? 56
                            : 40),
                    if (!isLastPage)
                      TextButton(
                        onPressed: () => context.go(AppRoutes.register),
                        child: Text(
                          'Skip',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.c.textSecondary,
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
                        // Hero illustration (falls back to an icon if the asset
                        // hasn't been added yet).
                        Image.asset(
                          slide.image,
                          height: 320,
                          fit: BoxFit.contain,
                          // Cap decode size — large source PNGs were heavy to
                          // decode on slower runtimes (simulator/emulator/web).
                          cacheWidth: 820,
                          filterQuality: FilterQuality.medium,
                          errorBuilder: (context, error, stack) => Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: context.c.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              slide.fallbackIcon,
                              color: AppColors.primary,
                              size: 56,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: context.c.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.subtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            color: context.c.textSecondary,
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
                  dotColor: context.c.primaryLight,
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                  spacing: 6,
                ),
              ),
            ),

            // CTA area (width-capped so buttons don't stretch on desktop)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
