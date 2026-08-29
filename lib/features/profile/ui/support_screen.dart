import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

// ─── Mock FAQs ────────────────────────────────────────────────────────────────

const _faqs = [
  {
    'q': 'How do I create a listing?',
    'a':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris.',
  },
  {
    'q': 'How do I manage bookings?',
    'a':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris.',
  },
  {
    'q': 'How does escrow payment work?',
    'a':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris.',
  },
  {
    'q': 'How do I withdraw my earnings?',
    'a':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris.',
  },
  {
    'q': 'What fees does Planovar charge?',
    'a':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris.',
  },
  {
    'q': 'How do I verify my account?',
    'a':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris.',
  },
  {
    'q': 'Can I cancel a booking?',
    'a':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris.',
  },
  {
    'q': 'How do reviews work?',
    'a':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris.',
  },
  {
    'q': 'How do I upgrade my subscription?',
    'a':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris.',
  },
  {
    'q': 'How do I contact a client?',
    'a':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris.',
  },
];

// ─── Gradient AppBar helper ───────────────────────────────────────────────────

Widget _buildGradientAppBar(
  BuildContext context, {
  required String title,
  String? subtitle,
  List<Widget>? trailingWidgets,
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
          child: Column(
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
        if (trailingWidgets != null) ...trailingWidgets,
      ],
    ),
  );
}

// ─── _SupportRow widget ───────────────────────────────────────────────────────

class _SupportRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SupportRow({
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
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
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
              child: Icon(icon, color: AppColors.primary, size: 22),
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

// ─── SupportScreen ────────────────────────────────────────────────────────────

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final name = authState is AuthAuthenticated ? authState.user.name : '';
    final firstName = name.isNotEmpty ? name.split(' ').first : 'there';

    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          _buildGradientAppBar(context, title: 'Support'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              children: [
                const SizedBox(height: 20),
                Text(
                  'Hey, $firstName 👋',
                  style: GoogleFonts.urbanist(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: context.c.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                // Search bar
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.c.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: context.c.divider),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded,
                          color: context.c.textHint, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'How can we help you?',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: context.c.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Gradient promo banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Top-Notch support system',
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Get quick responses with our online chat',
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chat_bubble_rounded,
                        size: 48,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // FAQ card
                Container(
                  decoration: BoxDecoration(
                    color: context.c.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Frequently Asked Questions',
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: context.c.textPrimary,
                          ),
                        ),
                      ),
                      ...List.generate(3, (i) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  context.push('/profile/support/faq'),
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _faqs[i]['q']!,
                                        style: GoogleFonts.urbanist(
                                          fontSize: 14,
                                          color: context.c.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: context.c.textHint,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                                height: 1, color: context.c.divider),
                          ],
                        );
                      }),
                      GestureDetector(
                        onTap: () => context.push('/profile/support/faq'),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Center(
                            child: Text(
                              'View More Questions',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SupportRow(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Chat',
                  subtitle: 'Need help? We are here for you',
                  onTap: () => context.push('/profile/support/live-chat'),
                ),
                const SizedBox(height: 8),
                _SupportRow(
                  icon: Icons.phone_outlined,
                  title: 'Call Support',
                  subtitle: 'Available Mon - Fri, 9am - 5pm',
                  onTap: () => context.push('/profile/support/call'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FaqScreen ────────────────────────────────────────────────────────────────

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          Container(
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
                  child: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Frequently Asked Questions',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'FAQ',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _faqs.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: context.c.divider),
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () =>
                      context.push('/profile/support/faq/$i'),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _faqs[i]['q']!,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: context.c.textPrimary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: context.c.textHint,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FaqDetailScreen ──────────────────────────────────────────────────────────

class FaqDetailScreen extends StatelessWidget {
  final int index;

  const FaqDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    const lorem =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut et massa mi. Aliquam in hendrerit urna. Pellentesque sit amet sapien fringilla, mattis ligula consectetur, ultrices mauris. Maecenas vitae mattis tellus. Nullam quis imperdiet augue. Vestibulum auctor ornare leo, non suscipit magna interdum eu. Curabitur pellentesque nibh nibh, at maximus ante fermentum sit amet.';

    return Scaffold(
      backgroundColor: context.c.surface,
      body: Column(
        children: [
          _buildGradientAppBar(
            context,
            title: 'Question ${index + 1}',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lorem,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: context.c.textPrimary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lorem,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: context.c.textPrimary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    lorem,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: context.c.textPrimary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'I need more help',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: context.c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () =>
                        context.push('/profile/support/live-chat'),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: context.c.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: context.c.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
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
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Chat with us',
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: context.c.textPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: context.c.textHint,
                            size: 20,
                          ),
                        ],
                      ),
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

// ─── CallSupportScreen ────────────────────────────────────────────────────────

class CallSupportScreen extends StatelessWidget {
  const CallSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.surface,
      body: Column(
        children: [
          _buildGradientAppBar(context, title: 'Call Us'),
          Expanded(
            child: Column(
              children: [
                const Spacer(),
                const Icon(
                  Icons.support_agent_rounded,
                  size: 120,
                  color: AppColors.primary,
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: context.c.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '09008747234573',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    "We're available from Monday- Friday from 9am - 5pm",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: context.c.textSecondary,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ─── LiveChatScreen (Crisp) ─────────────────────────────────────────────────
// Live support via Crisp. The website ID is supplied at build time:
//   --dart-define=CRISP_WEBSITE_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
// Mobile shows the Crisp chatbox in an in-app WebView; web opens it in a new
// tab (webview_flutter has no web implementation). Until the ID is configured,
// a friendly placeholder with an email fallback is shown.

const String _kCrispWebsiteId =
    String.fromEnvironment('CRISP_WEBSITE_ID', defaultValue: '');
const String _kSupportEmail = 'support@planovar.ng';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  WebViewController? _controller;

  String get _chatUrl =>
      'https://go.crisp.chat/chat/embed/?website_id=$_kCrispWebsiteId';

  @override
  void initState() {
    super.initState();
    if (_kCrispWebsiteId.isNotEmpty && !kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(_chatUrl));
    }
  }

  Future<void> _openInBrowser() async {
    await launchUrl(Uri.parse(_chatUrl),
        mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank');
  }

  Future<void> _emailSupport() async {
    await launchUrl(Uri.parse('mailto:$_kSupportEmail'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          _buildGradientAppBar(context,
              title: 'Live Support',
              subtitle: 'We usually reply in a few minutes'),
          Expanded(child: _body(context)),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (_kCrispWebsiteId.isEmpty) {
      return _placeholder(
        context,
        icon: Icons.support_agent_rounded,
        title: 'Live chat is being set up',
        message:
            "Our live chat isn't connected yet. In the meantime, email us and "
            "we'll get right back to you.",
        actionLabel: 'Email support',
        onAction: _emailSupport,
      );
    }
    if (kIsWeb) {
      return _placeholder(
        context,
        icon: Icons.chat_bubble_outline_rounded,
        title: 'Chat with our team',
        message: 'Open our live chat to talk to a support agent.',
        actionLabel: 'Open live chat',
        onAction: _openInBrowser,
      );
    }
    return WebViewWidget(controller: _controller!);
  }

  Widget _placeholder(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: context.c.textPrimary)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                    fontSize: 14, color: context.c.textSecondary, height: 1.5)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(actionLabel,
                  style: GoogleFonts.urbanist(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
