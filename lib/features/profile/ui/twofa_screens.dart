import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

// ─── Gradient button helper ───────────────────────────────────────────────────

class _GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Gradient AppBar Container helper ────────────────────────────────────────

Widget _buildGradientAppBar(
  BuildContext context, {
  required String title,
  String? subtitle,
  bool centerTitle = true,
  List<Widget>? actions,
}) {
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
        const SizedBox(width: 12),
        Expanded(
          child: centerTitle
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.urbanist(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
        ),
        if (actions != null) ...actions else const SizedBox(width: 36),
      ],
    ),
  );
}

// ─── TwoFAIntroScreen ─────────────────────────────────────────────────────────

class TwoFAIntroScreen extends StatelessWidget {
  const TwoFAIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Back button top-left
            Positioned(
              top: 8,
              left: 16,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
            ),

            // Body
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Shield illustration with sparkles
                        SizedBox(
                          width: 160,
                          height: 160,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Blue circle with shield icon
                              Container(
                                width: 120,
                                height: 120,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFAAA8F7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.security_rounded,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                              // Sparkles
                              const Positioned(
                                top: 6,
                                left: 16,
                                child: Icon(Icons.auto_awesome_rounded,
                                    size: 16, color: AppColors.primary),
                              ),
                              const Positioned(
                                top: 0,
                                left: 72,
                                child: Icon(Icons.auto_awesome_rounded,
                                    size: 16, color: AppColors.primary),
                              ),
                              const Positioned(
                                top: 6,
                                right: 16,
                                child: Icon(Icons.auto_awesome_rounded,
                                    size: 16, color: AppColors.primary),
                              ),
                              const Positioned(
                                right: 4,
                                top: 72,
                                child: Icon(Icons.auto_awesome_rounded,
                                    size: 16, color: AppColors.primary),
                              ),
                              const Positioned(
                                bottom: 6,
                                right: 16,
                                child: Icon(Icons.auto_awesome_rounded,
                                    size: 16, color: AppColors.primary),
                              ),
                              const Positioned(
                                bottom: 6,
                                left: 16,
                                child: Icon(Icons.auto_awesome_rounded,
                                    size: 16, color: AppColors.primary),
                              ),
                              const Positioned(
                                left: 4,
                                top: 72,
                                child: Icon(Icons.auto_awesome_rounded,
                                    size: 16, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Enable 2FA for additional security',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom button
                Padding(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: bottomPadding + 24,
                  ),
                  child: _GradientButton(
                    label: 'Get Started',
                    onTap: () => context.push('/profile/2fa/setup'),
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

// ─── TwoFASetupScreen ─────────────────────────────────────────────────────────

class TwoFASetupScreen extends StatelessWidget {
  const TwoFASetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildGradientAppBar(
            context,
            title: '2FA Setup',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                Text(
                  'Set up using',
                  style: GoogleFonts.urbanist(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Using the authenticator app such as (Google Authenticator, Authy, 1Password, Last pass etc',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                // QR Code placeholder
                Center(
                  child: Container(
                    width: 180,
                    height: 180,
                    color: Colors.black,
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_2_rounded,
                        size: 160,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _GradientButton(
                  label: 'Scan Me',
                  onTap: () => context.push('/profile/2fa/confirm'),
                ),
                const SizedBox(height: 16),
                Text(
                  "If you can't scan the QR code above, enter this text instead",
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '48hd8b 94u83b c88b3 f9vb',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.copy_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── TwoFAConfirmScreen ───────────────────────────────────────────────────────

class TwoFAConfirmScreen extends StatefulWidget {
  const TwoFAConfirmScreen({super.key});

  @override
  State<TwoFAConfirmScreen> createState() => _TwoFAConfirmScreenState();
}

class _TwoFAConfirmScreenState extends State<TwoFAConfirmScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final code = _controller.text;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildGradientAppBar(context, title: 'Confirm Code'),
          Expanded(
            child: GestureDetector(
              onTap: () => _focusNode.requestFocus(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Confirm Code',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the code provided by the authenticator app',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // OTP boxes with hidden text field
                    Stack(
                      children: [
                        // Hidden text field
                        Opacity(
                          opacity: 0,
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: const InputDecoration(
                              counterText: '',
                            ),
                          ),
                        ),
                        // Visual OTP boxes
                        GestureDetector(
                          onTap: () => _focusNode.requestFocus(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (i) {
                              final isFilled = i < code.length;
                              final isActive = i == code.length;
                              return Container(
                                width: 52,
                                height: 60,
                                margin: EdgeInsets.only(
                                    right: i < 5 ? 8 : 0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isFilled || isActive
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: isFilled || isActive ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    isFilled ? code[i] : '',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                    _GradientButton(
                      label: 'Confirm',
                      onTap: () => context.push('/profile/2fa/success'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── TwoFASuccessScreen ───────────────────────────────────────────────────────

class TwoFASuccessScreen extends StatelessWidget {
  const TwoFASuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 96,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.urbanist(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      children: [
                        const TextSpan(text: 'All '),
                        TextSpan(
                          text: 'done',
                          style: GoogleFonts.urbanist(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Your 2FA has been successfully enabled',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: bottomPadding + 24,
              ),
              child: _GradientButton(
                label: 'Back to profile setup',
                onTap: () => context.go('/profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
