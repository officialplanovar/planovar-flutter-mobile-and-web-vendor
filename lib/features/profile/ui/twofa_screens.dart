import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';

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

class TwoFAIntroScreen extends StatefulWidget {
  const TwoFAIntroScreen({super.key});

  @override
  State<TwoFAIntroScreen> createState() => _TwoFAIntroScreenState();
}

class _TwoFAIntroScreenState extends State<TwoFAIntroScreen> {
  bool _enabled = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final e = await AuthRepository().isTwoFactorEnabled();
      if (mounted) setState(() => _enabled = e);
    } catch (_) {}
  }

  Future<String?> _promptPassword() async {
    final ctrl = TextEditingController();
    final t = AppLocalizations.of(context);
    final pw = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.twofaConfirmPasswordTitle),
        content: TextField(
          controller: ctrl,
          obscureText: true,
          autofocus: true,
          decoration: InputDecoration(hintText: t.psCurrentPasswordHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: Text(t.twofaContinue),
          ),
        ],
      ),
    );
    ctrl.dispose();
    return pw;
  }

  Future<void> _onPrimary() async {
    if (_busy) return;
    final pw = await _promptPassword();
    if (pw == null || pw.isEmpty || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final t = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      if (_enabled) {
        await AuthRepository().disableTwoFactor(pw);
        if (!mounted) return;
        setState(() => _enabled = false);
        messenger.showSnackBar(SnackBar(content: Text(t.twofaDisabled)));
      } else {
        final data = await AuthRepository().enableTwoFactor(pw);
        if (!mounted) return;
        final totpUri = data['totpURI'] as String? ?? '';
        final codes = (data['backupCodes'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            <String>[];
        context.push('/profile/2fa/setup',
            extra: {'totpURI': totpUri, 'backupCodes': codes});
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
        backgroundColor: AppColors.error,
      ));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: context.c.surface,
      body: SafeArea(
        child: Stack(
          children: [
            // Back button top-left
            Positioned(
              top: 8,
              left: 16,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: context.c.textPrimary,
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
                            AppLocalizations.of(context).twofaIntroTitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: context.c.textPrimary,
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
                    label: _busy
                        ? AppLocalizations.of(context).loading
                        : (_enabled
                            ? AppLocalizations.of(context).twofaDisable
                            : AppLocalizations.of(context).twofaGetStarted),
                    onTap: _onPrimary,
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
  final String totpUri;
  final List<String> backupCodes;
  const TwoFASetupScreen({
    super.key,
    required this.totpUri,
    required this.backupCodes,
  });

  String get _manualSecret {
    try {
      return Uri.parse(totpUri).queryParameters['secret'] ?? '';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          _buildGradientAppBar(
            context,
            title: t.twofaSetupTitle,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              children: [
                Text(
                  t.twofaSetUpUsing,
                  style: GoogleFonts.urbanist(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: context.c.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.twofaAuthenticatorHint,
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: context.c.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                // Real TOTP QR code (scan in an authenticator app).
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.white,
                    child: QrImageView(
                      data: totpUri,
                      version: QrVersions.auto,
                      size: 180,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _GradientButton(
                  label: t.twofaScanMe,
                  onTap: () => context.push('/profile/2fa/confirm'),
                ),
                const SizedBox(height: 16),
                Text(
                  t.twofaCantScan,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: context.c.textSecondary,
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
                          color: context.c.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SelectableText(
                          _manualSecret,
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: context.c.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: _manualSecret));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(t.twofaSecretCopied)),
                        );
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: context.c.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.copy_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                if (backupCodes.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text(
                    t.twofaBackupCodesTitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.twofaBackupCodesHint,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: context.c.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.c.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      backupCodes.join('\n'),
                      style: GoogleFonts.robotoMono(
                        fontSize: 14,
                        height: 1.6,
                        color: context.c.textPrimary,
                      ),
                    ),
                  ),
                ],
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

  bool _verifying = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_verifying) return;
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final code = _controller.text.trim();
    if (code.length < 6) {
      messenger.showSnackBar(SnackBar(content: Text(t.twofaEnterCode)));
      return;
    }
    setState(() => _verifying = true);
    try {
      await AuthRepository().verifyTotp(code);
      if (!mounted) return;
      context.push('/profile/2fa/success');
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(
        content: Text(e.toString().replaceFirst('Exception: ', '')),
        backgroundColor: AppColors.error,
      ));
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final code = _controller.text;

    return Scaffold(
      backgroundColor: context.c.surface,
      body: Column(
        children: [
          _buildGradientAppBar(context, title: t.twofaConfirmCode),
          Expanded(
            child: GestureDetector(
              onTap: () => _focusNode.requestFocus(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      t.twofaConfirmCode,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: context.c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.twofaEnterCode,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: context.c.textSecondary,
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
                                        : context.c.border,
                                    width: isFilled || isActive ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: context.c.surface,
                                ),
                                child: Center(
                                  child: Text(
                                    isFilled ? code[i] : '',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: context.c.textPrimary,
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
                      label: _verifying ? t.loading : t.twofaConfirm,
                      onTap: _verify,
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
    final t = AppLocalizations.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: context.c.surface,
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
                        color: context.c.textPrimary,
                      ),
                      children: [
                        TextSpan(text: t.twofaAllPrefix),
                        TextSpan(
                          text: t.twofaDoneWord,
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
                      t.twofaSuccessBody,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        color: context.c.textSecondary,
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
                label: t.twofaBackToProfile,
                onTap: () => context.go('/profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
