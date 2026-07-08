import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

// ─── Gradient AppBar helper ───────────────────────────────────────────────────

Widget _buildGradientAppBar(BuildContext context, {required String title}) {
  final topPadding = MediaQuery.of(context).padding.top;
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    padding: EdgeInsets.only(
      top: topPadding + 12,
      left: 16,
      right: 16,
      bottom: 16,
    ),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 24),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
      ],
    ),
  );
}

// ─── _TermsRow ────────────────────────────────────────────────────────────────

class _TermsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TermsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.c.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: context.c.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: context.c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              color: context.c.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── TermsAndConditionsScreen ─────────────────────────────────────────────────

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          _buildGradientAppBar(context, title: 'Terms & Conditions'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  _TermsRow(
                    icon: Icons.article_outlined,
                    title: 'Terms and Conditions',
                    subtitle: 'Last updated 17th April 2025',
                    onTap: () => context.push('/profile/terms/use'),
                  ),
                  const SizedBox(height: 12),
                  _TermsRow(
                    icon: Icons.description_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Read our privacy agreement',
                    onTap: () => context.push('/profile/terms/privacy'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Lorem ipsum body ─────────────────────────────────────────────────────────

const _loremParagraph =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. '
    'Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis '
    'ligula consectetur, ultrices mauris. Maecenas vitae mattis tellus. Nullam '
    'quis imperdiet augue. Vestibulum auctor ornare leo, non suscipit magna '
    'interdum eu. Curabitur pellentesque nibh nibh, at maximus ante fermentum '
    'sit amet.';

// ─── TermsOfUseScreen ─────────────────────────────────────────────────────────

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.surface,
      body: Column(
        children: [
          _buildGradientAppBar(context, title: 'Terms of Use'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _loremParagraph,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: context.c.textPrimary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _loremParagraph,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: context.c.textPrimary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _loremParagraph,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: context.c.textPrimary,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PrivacyPolicyScreen ──────────────────────────────────────────────────────

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.surface,
      body: Column(
        children: [
          _buildGradientAppBar(context, title: 'Privacy Policy'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _loremParagraph,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: context.c.textPrimary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _loremParagraph,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: context.c.textPrimary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _loremParagraph,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: context.c.textPrimary,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
