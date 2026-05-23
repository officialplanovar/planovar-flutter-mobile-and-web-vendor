import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../core/mock/mock_data.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';

// ─── Edit Profile Screen ──────────────────────────────────────────────────────

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final vendor = MockData.currentVendor;
    final user = MockData.currentUser;
    _nameCtrl = TextEditingController(text: vendor.businessName);
    _descCtrl = TextEditingController(text: vendor.description ?? '');
    _phoneCtrl = TextEditingController(text: vendor.phone ?? user.phone);
    _emailCtrl = TextEditingController(text: vendor.email ?? user.email);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated successfully',
            style: GoogleFonts.urbanist(fontSize: 14),
          ),
          backgroundColor: AppColors.activeText,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary),
        title: Text(
          'Edit Business Profile',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppInput(
            label: 'Business Name',
            hint: 'Your business name',
            controller: _nameCtrl,
          ),
          const SizedBox(height: 16),
          AppInput(
            label: 'Description',
            hint: 'Tell customers about your business...',
            controller: _descCtrl,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          ),
          const SizedBox(height: 16),
          AppInput(
            label: 'Phone Number',
            hint: '+234...',
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),
          AppInput(
            label: 'Email Address',
            hint: 'business@email.com',
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 32),
          AppButton(
            label: 'Save Changes',
            onTap: _saving ? null : _save,
            loading: _saving,
          ),
        ],
      ),
    );
  }
}

// ─── Subscription Plan Screen ─────────────────────────────────────────────────

class SubscriptionPlanScreen extends StatelessWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTier = MockData.currentVendor.subscriptionTier;
    final plans = [
      _PlanData(
        id: 'basic',
        name: 'Basic',
        price: 'Free',
        description: 'Get started with core listing features.',
        features: [
          'Up to 5 listings',
          'Basic analytics',
          'Standard support',
        ],
      ),
      _PlanData(
        id: 'featured',
        name: 'Featured',
        price: '₦9,999/mo',
        description: 'Stand out and get more bookings.',
        features: [
          'Up to 20 listings',
          'Featured badge',
          'Priority in search results',
          'Advanced analytics',
          'Priority support',
        ],
        highlighted: true,
      ),
      _PlanData(
        id: 'premium',
        name: 'Premium',
        price: '₦24,999/mo',
        description: 'Full power for serious vendors.',
        features: [
          'Unlimited listings',
          'Premium badge',
          'Top placement in search',
          'Full analytics suite',
          'Dedicated account manager',
          'Custom portfolio page',
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary),
        title: Text(
          'Subscription Plan',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Choose your plan',
            style: GoogleFonts.urbanist(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Upgrade to unlock more features and grow your business.',
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ...plans.map((plan) => _PlanCard(
                plan: plan,
                isCurrent: plan.id == currentTier,
              )),
        ],
      ),
    );
  }
}

class _PlanData {
  final String id;
  final String name;
  final String price;
  final String description;
  final List<String> features;
  final bool highlighted;

  const _PlanData({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.features,
    this.highlighted = false,
  });
}

class _PlanCard extends StatelessWidget {
  final _PlanData plan;
  final bool isCurrent;

  const _PlanCard({required this.plan, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: plan.highlighted ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: plan.highlighted ? AppColors.primary : AppColors.border,
          width: plan.highlighted ? 2 : 1,
        ),
        boxShadow: [
          if (plan.highlighted)
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                plan.name,
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: plan.highlighted ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: plan.highlighted
                        ? Colors.white.withValues(alpha: 0.2)
                        : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Current',
                    style: GoogleFonts.urbanist(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: plan.highlighted ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              const Spacer(),
              Text(
                plan.price,
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: plan.highlighted ? Colors.white : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            plan.description,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: plan.highlighted
                  ? Colors.white.withValues(alpha: 0.8)
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          ...plan.features.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: plan.highlighted
                          ? Colors.white
                          : AppColors.activeText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      f,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: plan.highlighted
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          if (!isCurrent)
            AppButton(
              label: 'Upgrade to ${plan.name}',
              onTap: () {},
              variant: plan.highlighted
                  ? ButtonVariant.secondary
                  : ButtonVariant.primary,
            ),
          if (isCurrent)
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: plan.highlighted
                    ? Colors.white.withValues(alpha: 0.15)
                    : AppColors.divider,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Active Plan',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: plan.highlighted ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Bank Details Screen ──────────────────────────────────────────────────────

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  String? _selectedBank;
  final _accountNumberCtrl = TextEditingController(text: '0123454421');
  final _accountNameCtrl = TextEditingController(text: 'Chidinma Okafor');
  bool _saving = false;

  final _banks = [
    'Zenith Bank',
    'GTBank',
    'Access Bank',
    'First Bank',
    'UBA',
    'Fidelity Bank',
    'Kuda Bank',
    'Opay',
    'Palmpay',
    'Sterling Bank',
  ];

  @override
  void initState() {
    super.initState();
    _selectedBank = 'Zenith Bank';
  }

  @override
  void dispose() {
    _accountNumberCtrl.dispose();
    _accountNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bank details saved',
            style: GoogleFonts.urbanist(fontSize: 14),
          ),
          backgroundColor: AppColors.activeText,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary),
        title: Text(
          'Bank Details',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.activeBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppColors.activeText, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Payouts are sent to this bank account after order completion.',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: AppColors.activeText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bank dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bank Name',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedBank,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary),
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                    onChanged: (v) => setState(() => _selectedBank = v),
                    items: _banks
                        .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          AppInput(
            label: 'Account Number',
            hint: 'Enter 10-digit account number',
            controller: _accountNumberCtrl,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          AppInput(
            label: 'Account Name',
            hint: 'Account name',
            controller: _accountNameCtrl,
            readOnly: true,
          ),
          const SizedBox(height: 32),
          AppButton(
            label: 'Save Bank Details',
            onTap: _saving ? null : _save,
            loading: _saving,
          ),
        ],
      ),
    );
  }
}

// ─── Theme Settings Screen ────────────────────────────────────────────────────

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, currentMode) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: BackButton(color: AppColors.textPrimary),
            title: Text(
              'Theme',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ThemeOption(
                  icon: Icons.light_mode_rounded,
                  label: 'Light',
                  subtitle: 'Always use light mode',
                  isSelected: currentMode == ThemeMode.light,
                  onTap: () => context.read<ThemeCubit>().setLight(),
                ),
                const Divider(height: 1, color: AppColors.divider),
                _ThemeOption(
                  icon: Icons.dark_mode_rounded,
                  label: 'Dark',
                  subtitle: 'Always use dark mode',
                  isSelected: currentMode == ThemeMode.dark,
                  onTap: () => context.read<ThemeCubit>().setDark(),
                ),
                const Divider(height: 1, color: AppColors.divider),
                _ThemeOption(
                  icon: Icons.brightness_auto_rounded,
                  label: 'System',
                  subtitle: 'Follow device settings',
                  isSelected: currentMode == ThemeMode.system,
                  onTap: () => context.read<ThemeCubit>().setSystem(),
                  isLast: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isLast;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isLast ? const Radius.circular(16) : Radius.zero,
            bottomRight: isLast ? const Radius.circular(16) : Radius.zero,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.divider,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── Security Screen ──────────────────────────────────────────────────────────

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _saving = false;

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final newPass = _newPasswordCtrl.text.trim();
    final confirmPass = _confirmPasswordCtrl.text.trim();
    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Passwords do not match',
            style: GoogleFonts.urbanist(fontSize: 14),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _saving = false);
      _currentPasswordCtrl.clear();
      _newPasswordCtrl.clear();
      _confirmPasswordCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password changed successfully',
            style: GoogleFonts.urbanist(fontSize: 14),
          ),
          backgroundColor: AppColors.activeText,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary),
        title: Text(
          'Security',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Change Password',
            style: GoogleFonts.urbanist(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose a strong password that you have not used before.',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          AppInput(
            label: 'Current Password',
            hint: 'Enter current password',
            controller: _currentPasswordCtrl,
            obscureText: _obscureCurrent,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscureCurrent = !_obscureCurrent),
              child: Icon(
                _obscureCurrent ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.textHint,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppInput(
            label: 'New Password',
            hint: 'Enter new password',
            controller: _newPasswordCtrl,
            obscureText: _obscureNew,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscureNew = !_obscureNew),
              child: Icon(
                _obscureNew ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.textHint,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppInput(
            label: 'Confirm New Password',
            hint: 'Confirm new password',
            controller: _confirmPasswordCtrl,
            obscureText: _obscureConfirm,
            textInputAction: TextInputAction.done,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
              child: Icon(
                _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.textHint,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 32),
          AppButton(
            label: 'Change Password',
            onTap: _saving ? null : _changePassword,
            loading: _saving,
          ),
        ],
      ),
    );
  }
}

// ─── Help Screen ──────────────────────────────────────────────────────────────

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faqs = [
    (
      question: 'How do I get paid for completed orders?',
      answer:
          'Payments are held in escrow until you mark an order as completed and the client confirms delivery. Funds are then automatically transferred to your linked bank account within 2 business days.',
    ),
    (
      question: 'What commission does Planovar charge?',
      answer:
          'Planovar charges a 9% service fee on each completed transaction. This covers payment processing, platform maintenance, and customer support.',
    ),
    (
      question: 'How do I update my listing prices?',
      answer:
          'Go to Listings, tap on the listing you want to update, then tap "Edit Listing". You can update your pricing, description, and photos from there.',
    ),
    (
      question: 'What happens if a client cancels a booking?',
      answer:
          'If a client cancels before the cancellation window (usually 48–72 hours before the event), you may be entitled to a cancellation fee based on your cancellation policy. Planovar enforces this automatically.',
    ),
    (
      question: 'How do I upgrade my subscription plan?',
      answer:
          'Go to Profile → Subscription Plan and choose the plan that suits you. Upgrades take effect immediately, and your billing is prorated for the remainder of the current month.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary),
        title: Text(
          'Help & Support',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Contact card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help?',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Our support team is available Mon–Fri, 9am–6pm WAT.',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _ContactButton(
                      icon: Icons.chat_rounded,
                      label: 'Live Chat',
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    _ContactButton(
                      icon: Icons.email_rounded,
                      label: 'Email Us',
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Frequently Asked Questions',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: _faqs.asMap().entries.map((entry) {
                final i = entry.key;
                final faq = entry.value;
                return Column(
                  children: [
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        title: Text(
                          faq.question,
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        children: [
                          Text(
                            faq.answer,
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < _faqs.length - 1)
                      const Divider(height: 1, color: AppColors.divider),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Notifications Settings Screen ───────────────────────────────────────────

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _newBookings = true;
  bool _payments = true;
  bool _reviews = true;
  bool _promotions = false;
  bool _appUpdates = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppColors.textPrimary),
        title: Text(
          'Notifications',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _NotifToggle(
              label: 'New Bookings',
              subtitle: 'When a client makes a new booking',
              value: _newBookings,
              onChanged: (v) => setState(() => _newBookings = v),
            ),
            const Divider(height: 1, color: AppColors.divider),
            _NotifToggle(
              label: 'Payments',
              subtitle: 'Payment received and payout alerts',
              value: _payments,
              onChanged: (v) => setState(() => _payments = v),
            ),
            const Divider(height: 1, color: AppColors.divider),
            _NotifToggle(
              label: 'Reviews',
              subtitle: 'When you receive a new review',
              value: _reviews,
              onChanged: (v) => setState(() => _reviews = v),
            ),
            const Divider(height: 1, color: AppColors.divider),
            _NotifToggle(
              label: 'Promotions',
              subtitle: 'Tips and promotional content from Planovar',
              value: _promotions,
              onChanged: (v) => setState(() => _promotions = v),
            ),
            const Divider(height: 1, color: AppColors.divider),
            _NotifToggle(
              label: 'App Updates',
              subtitle: 'New features and improvements',
              value: _appUpdates,
              onChanged: (v) => setState(() => _appUpdates = v),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifToggle extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _NotifToggle({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.urbanist(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
