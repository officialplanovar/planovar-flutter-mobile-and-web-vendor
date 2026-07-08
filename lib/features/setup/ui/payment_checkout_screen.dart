import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';

/// Opens the Paystack checkout in the device browser (reliable for the heavy
/// checkout SPA, unlike an in-app WebView) and asks the user to confirm when
/// they're done. Pops the transaction [reference] on "I've completed payment",
/// or `null` if cancelled. The caller then verifies the payment server-side.
class PaymentCheckoutScreen extends StatefulWidget {
  const PaymentCheckoutScreen({
    super.key,
    required this.checkoutUrl,
    required this.reference,
  });

  final String checkoutUrl;
  final String reference;

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  bool _launchFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _open());
  }

  Future<void> _open() async {
    final uri = Uri.parse(widget.checkoutUrl);
    bool ok = false;
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (mounted) setState(() => _launchFailed = !ok);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.surface,
      appBar: AppBar(
        backgroundColor: context.c.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: context.c.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Complete payment',
          style: GoogleFonts.urbanist(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: context.c.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: context.c.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline_rounded,
                  color: AppColors.primary, size: 38),
            ),
            const SizedBox(height: 24),
            Text(
              'Secure payment',
              style: GoogleFonts.urbanist(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: context.c.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _launchFailed
                  ? "We couldn't open your browser. Tap below to open the secure Paystack checkout."
                  : "We've opened the secure Paystack checkout in your browser. Finish your payment there, then come back and tap the button below.",
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: context.c.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: _open,
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(
                _launchFailed ? 'Open payment page' : 'Reopen payment page',
                style: GoogleFonts.urbanist(fontWeight: FontWeight.w600),
              ),
            ),
            const Spacer(),
            AppButton.primary(
              "I've completed payment",
              onTap: () => Navigator.of(context).pop(widget.reference),
            ),
            const SizedBox(height: 10),
            AppButton.ghost(
              'Cancel',
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
