import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../shared/models/subscription_plan_model.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/network_image_widget.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../setup/ui/payment_checkout_screen.dart';
import '../../subscription/data/subscription_repository.dart';
import '../../vendor/data/vendor_repository.dart';

// ─── Shared helpers ──────────────────────────────────────────────────────────

const _kGradient = LinearGradient(
  colors: [Color(0xFF5756F5), Color(0xFF3332D4)],
);

/// Gradient AppBar container used by every screen.
/// [title] is the widget placed in the center (after the back button).
Widget _buildGradientAppBar(
  BuildContext context, {
  required Widget title,
}) {
  final topPadding = MediaQuery.of(context).padding.top;
  return Container(
    decoration: const BoxDecoration(gradient: _kGradient),
    padding: EdgeInsets.fromLTRB(16, topPadding + 12, 16, 16),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: title),
      ],
    ),
  );
}

Widget _gradientButton({
  required BuildContext context,
  required String label,
  required VoidCallback onTap,
  EdgeInsets? margin,
}) {
  return Container(
    margin: margin,
    width: double.infinity,
    height: 52,
    decoration: BoxDecoration(
      gradient: _kGradient,
      borderRadius: BorderRadius.circular(26),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
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
    ),
  );
}

Widget _fieldLabel(String label) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );

InputDecoration _filledDecoration({String? hint, Widget? prefix, Widget? suffix}) =>
    InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.urbanist(fontSize: 14, color: AppColors.textHint),
      filled: true,
      fillColor: AppColors.backgroundLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      prefixIcon: prefix,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );

// ─── 1. EditProfileScreen ─────────────────────────────────────────────────────

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  int _tabIndex = 0;

  String? _logoUrl;

  // Personal
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String _countryCode = '+234';
  int _dobDay = 30;
  String _dobMonth = 'March';
  int _dobYear = 1999;

  // Business
  final _businessNameCtrl = TextEditingController();
  String _businessType = 'Licensed Business';
  final _descCtrl = TextEditingController();
  List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthBloc>().state;
    if (auth is AuthAuthenticated) {
      _emailCtrl.text = auth.user.email;
      if ((auth.user.phone ?? '').isNotEmpty) {
        _phoneCtrl.text = auth.user.phone!.replaceFirst('+234', '');
      }
      _businessNameCtrl.text = auth.user.name;
    }
    VendorRepository().getMe().then((v) {
      if (!mounted || v == null) return;
      setState(() {
        _businessNameCtrl.text = v.businessName;
        _descCtrl.text = v.description ?? '';
        _selectedTags = List<String>.from(v.tags);
        _logoUrl = v.logoUrl;
        if ((v.email ?? '').isNotEmpty) _emailCtrl.text = v.email!;
        if ((v.phone ?? '').isNotEmpty) {
          _phoneCtrl.text = v.phone!.replaceFirst('+234', '');
        }
      });
    }).catchError((_) {});
  }

  static const _tagPool = [
    'Cakes',
    'Desserts',
    'Photography',
    'Catering',
    'Decor',
    'DJs',
    'Bands',
    'Products',
    'Rentals',
  ];

  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void dispose() {
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _businessNameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(Map<String, dynamic> changes) async {
    final messenger = ScaffoldMessenger.of(context);
    if (changes.isEmpty) return;
    try {
      await VendorRepository().updateProfile(changes);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('Profile updated', style: GoogleFonts.urbanist(fontSize: 14)),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.activeText,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildPersonalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Email Address'),
          TextField(
            controller: _emailCtrl,
            style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.textPrimary),
            decoration: _filledDecoration(hint: 'Email address'),
          ),
          const SizedBox(height: 16),
          _fieldLabel('Phone Number'),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _countryCode = _countryCode == '+234' ? '+1' : '+234';
                  });
                },
                child: Container(
                  width: 72,
                  height: 52,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      '$_countryCode ▾',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.textPrimary),
                  decoration: _filledDecoration(
                    hint: 'Phone number',
                    prefix: const Icon(Icons.phone_outlined, size: 18, color: AppColors.textHint),
                    suffix: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('🇳🇬', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _fieldLabel('Date of Birth'),
          Row(
            children: [
              // Day
              Expanded(
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _dobDay,
                      isExpanded: true,
                      style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.textPrimary),
                      items: List.generate(
                        31,
                        (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
                      ),
                      onChanged: (v) => setState(() => _dobDay = v!),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Month
              Expanded(
                flex: 2,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _dobMonth,
                      isExpanded: true,
                      style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.textPrimary),
                      items: _months
                          .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                          .toList(),
                      onChanged: (v) => setState(() => _dobMonth = v!),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Year
              Expanded(
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _dobYear,
                      isExpanded: true,
                      style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.textPrimary),
                      items: List.generate(
                        61,
                        (i) => DropdownMenuItem(
                          value: 1950 + i,
                          child: Text('${1950 + i}'),
                        ),
                      ),
                      onChanged: (v) => setState(() => _dobYear = v!),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _gradientButton(
            context: context,
            label: 'Update Details',
            onTap: () {
              final email = _emailCtrl.text.trim();
              final phone = _phoneCtrl.text.trim().replaceFirst(RegExp(r'^0+'), '');
              _save({
                if (email.isNotEmpty) 'email': email,
                if (phone.isNotEmpty) 'phone': '$_countryCode$phone',
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Business Name'),
          TextField(
            controller: _businessNameCtrl,
            style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.textPrimary),
            decoration: _filledDecoration(hint: 'Business name'),
          ),
          const SizedBox(height: 16),
          _fieldLabel('Business Type'),
          Row(
            children: ['Licensed Business', 'Freelancer'].map((type) {
              final selected = _businessType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _businessType = type),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: type == 'Licensed Business' ? 8 : 0,
                    ),
                    height: 44,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: Text(
                        type,
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          _fieldLabel('Business Description'),
          TextField(
            controller: _descCtrl,
            maxLines: 4,
            style: GoogleFonts.urbanist(fontSize: 14, color: AppColors.textPrimary),
            decoration: _filledDecoration(hint: 'Short description of your business'),
          ),
          const SizedBox(height: 16),
          _fieldLabel('Category Tags'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _tagPool.map((tag) {
              final selected = _selectedTags.contains(tag);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected) {
                      _selectedTags.remove(tag);
                    } else {
                      _selectedTags.add(tag);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.white,
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selected) ...[
                        GestureDetector(
                          onTap: () => setState(() => _selectedTags.remove(tag)),
                          child: const Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                      ] else ...[
                        const Icon(Icons.add, size: 14, color: AppColors.textPrimary),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        tag,
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          _gradientButton(
            context: context,
            label: 'Update Details',
            onTap: () {
              final name = _businessNameCtrl.text.trim();
              _save({
                if (name.length >= 2) 'businessName': name,
                'description': _descCtrl.text.trim(),
                'tags': _selectedTags,
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Gradient AppBar
          _buildGradientAppBar(
            context,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Edit your Profile',
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Avatar section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      child: ClipOval(
                        child: AppNetworkImage(
                          url: _logoUrl,
                          width: 104,
                          height: 104,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          gradient: _kGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _businessNameCtrl.text.isEmpty
                      ? 'Your business'
                      : _businessNameCtrl.text,
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _selectedTags.isEmpty
                      ? ''
                      : _selectedTags.take(2).join(' · '),
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Tab toggle
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTab(0, 'Personal Details'),
                const SizedBox(width: 8),
                _buildTab(1, 'Business Details'),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.divider),

          // Tab content
          Expanded(
            child: _tabIndex == 0 ? _buildPersonalTab() : _buildBusinessTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int index, String label) {
    final selected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── 2. SecurityScreen ────────────────────────────────────────────────────────

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildGradientAppBar(
            context,
            title: Center(
              child: Text(
                'Security',
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Column(
                children: [
                  _SecurityCard(
                    iconWidget: Stack(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.lock_outline_rounded,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: Color(0xFF22C55E),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: 'Change Password',
                    subtitle: 'Update your login password.',
                    onTap: () => context.push('/profile/security/change-password'),
                  ),
                  const SizedBox(height: 12),
                  _SecurityCard(
                    iconWidget: Stack(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '2FA',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF59E0B),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: '2FA Authentication',
                    subtitle: 'Add an extra layer of security.',
                    onTap: () => context.push('/profile/2fa'),
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

class _SecurityCard extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SecurityCard({
    required this.iconWidget,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            iconWidget,
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─── 3. ChangePasswordScreen ──────────────────────────────────────────────────

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();
  bool _showNew = false;
  bool _showConfirm = false;

  bool get _hasUpper => _newPwCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _newPwCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecial =>
      _newPwCtrl.text.contains(RegExp(r'[@$%!#^&*()_+=\-\[\]{};:,.<>?]'));
  int get _strengthLevel =>
      (_hasUpper ? 1 : 0) + (_hasNumber ? 1 : 0) + (_hasSpecial ? 1 : 0);

  @override
  void initState() {
    super.initState();
    _newPwCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  Color _segmentColor(int index) {
    if (_strengthLevel == 0) return AppColors.divider;
    if (_strengthLevel >= 3 && index == 3) return const Color(0xFF22C55E);
    if (_strengthLevel >= 1 && index < 2) return const Color(0xFFF59E0B);
    if (_strengthLevel >= 2 && index == 2) return const Color(0xFFF59E0B);
    return AppColors.divider;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildGradientAppBar(
            context,
            title: Center(
              child: Text(
                'Change Password',
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  _fieldLabel('New Password'),
                  TextField(
                    controller: _newPwCtrl,
                    obscureText: !_showNew,
                    style: GoogleFonts.urbanist(
                        fontSize: 14, color: AppColors.textPrimary),
                    decoration: _filledDecoration(
                      hint: 'Enter new password',
                      suffix: GestureDetector(
                        onTap: () => setState(() => _showNew = !_showNew),
                        child: Icon(
                          _showNew
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textHint,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _fieldLabel('Confirm Password'),
                  TextField(
                    controller: _confirmPwCtrl,
                    obscureText: !_showConfirm,
                    style: GoogleFonts.urbanist(
                        fontSize: 14, color: AppColors.textPrimary),
                    decoration: _filledDecoration(
                      hint: 'Confirm new password',
                      suffix: GestureDetector(
                        onTap: () =>
                            setState(() => _showConfirm = !_showConfirm),
                        child: Icon(
                          _showConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppColors.textHint,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Strength bar
                  Row(
                    children: List.generate(4, (i) {
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                          height: 4,
                          decoration: BoxDecoration(
                            color: _segmentColor(i),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  _requirementRow('Should have a Capital Letter', _hasUpper),
                  const SizedBox(height: 8),
                  _requirementRow(
                      'Should have a Number e.g 1,2,4,etc', _hasNumber),
                  const SizedBox(height: 8),
                  _requirementRow(
                      'Should have a Special Character e.g @,\$,%,etc',
                      _hasSpecial),
                  const Spacer(),
                ],
              ),
            ),
          ),
          _gradientButton(
            context: context,
            label: 'Save Password',
            margin: EdgeInsets.fromLTRB(
                24, 0, 24, bottomPad + 24),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password saved',
                      style: GoogleFonts.urbanist(fontSize: 14)),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.activeText,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _requirementRow(String label, bool met) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_rounded,
          size: 16,
          color: met ? AppColors.primary : AppColors.textHint,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: met ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── 4. ThemeSettingsScreen ───────────────────────────────────────────────────

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  String _selectedTheme = 'light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildGradientAppBar(
            context,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Select your preferred display',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _themeOption('light', 'Light', const Color(0xFFF5F5F5)),
                        const SizedBox(width: 8),
                        _themeOption('dark', 'Dark', const Color(0xFF1A1A2E)),
                        const SizedBox(width: 8),
                        _systemThemeOption(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _gradientButton(
                    context: context,
                    label: 'Save Preference',
                    onTap: () {
                      final cubit = context.read<ThemeCubit>();
                      if (_selectedTheme == 'light') {
                        cubit.setLight();
                      } else if (_selectedTheme == 'dark') {
                        cubit.setDark();
                      } else {
                        cubit.setSystem();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Theme preference saved',
                              style: GoogleFonts.urbanist(fontSize: 14)),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.activeText,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeOption(String value, String label, Color mockupColor) {
    final selected = _selectedTheme == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTheme = value),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 130,
                  decoration: BoxDecoration(
                    color: mockupColor,
                    borderRadius: BorderRadius.circular(16),
                    border: selected
                        ? Border.all(color: AppColors.primary, width: 2)
                        : Border.all(color: AppColors.border),
                  ),
                ),
                if (selected)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            if (selected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  label,
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _systemThemeOption() {
    final selected = _selectedTheme == 'system';
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTheme = 'system'),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: selected
                        ? Border.all(color: AppColors.primary, width: 2)
                        : Border.all(color: AppColors.border),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF5F5F5), Color(0xFF1A1A2E)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                if (selected)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'System',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            if (selected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'System',
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── 5. NotificationSettingsScreen ───────────────────────────────────────────

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  int _channelIndex = 0;
  bool _allMessages = false;
  bool _orderDelivery = false;
  bool _eventTimeline = false;
  bool _paymentAlerts = false;
  bool _quoteInvoice = false;

  static const _channelLabels = ['None', 'In app', 'Email', 'Both'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildGradientAppBar(
            context,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Select your preferred display',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Bell illustration
                  Container(
                    margin: const EdgeInsets.only(top: 24),
                    width: 160,
                    height: 160,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryLight.withValues(alpha: 0.3),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryLight.withValues(alpha: 0.5),
                          ),
                        ),
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All notifications',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Chose where you want to receive notifications',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Channel selector
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: List.generate(_channelLabels.length, (i) {
                              final sel = _channelIndex == i;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      setState(() => _channelIndex = i),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: sel
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _channelLabels[i],
                                        style: GoogleFonts.urbanist(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: sel
                                              ? Colors.white
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 24),
                        _notifToggle(
                          'All messages',
                          'someone replies your message',
                          _allMessages,
                          (v) => setState(() => _allMessages = v),
                        ),
                        _notifToggle(
                          'Order/ Delivery Timeline',
                          'get notified when an order is received / completed',
                          _orderDelivery,
                          (v) => setState(() => _orderDelivery = v),
                        ),
                        _notifToggle(
                          'Event Timeline',
                          'get notified when there\'s a new event timeline',
                          _eventTimeline,
                          (v) => setState(() => _eventTimeline = v),
                        ),
                        _notifToggle(
                          'Payment alerts',
                          'get notified when a payment is successful',
                          _paymentAlerts,
                          (v) => setState(() => _paymentAlerts = v),
                        ),
                        _notifToggle(
                          'Quote / Invoice alerts',
                          'get notified when your quote is acted on',
                          _quoteInvoice,
                          (v) => setState(() => _quoteInvoice = v),
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notifToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged, {
    bool isLast = false,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
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
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
        if (!isLast)
          const SizedBox(
            height: 1,
            child: ColoredBox(color: AppColors.divider),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ─── 6. BankDetailsScreen ─────────────────────────────────────────────────────

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  final List<Map<String, dynamic>> _accounts = [
    {
      'bank': 'GTBank',
      'number': '2385******',
      'name': 'Halima Fatokun',
      'isDefault': true,
    },
    {
      'bank': 'FirstBank',
      'number': '8573******',
      'name': 'Halima Fatokun',
      'isDefault': false,
    },
    {
      'bank': 'Ecobank',
      'number': '8485******',
      'name': 'Halima Fatokun',
      'isDefault': false,
    },
  ];

  bool _showAddForm = false;
  String? _selectedBank;
  final _accountCtrl = TextEditingController();
  bool _setAsDefault = true;

  static const _bankColors = {
    'GTBank': Color(0xFFE97520),
    'FirstBank': Color(0xFF003082),
    'Ecobank': Color(0xFF008751),
    'Zenith Bank': Color(0xFF8B0000),
    'Access Bank': Color(0xFFDD0000),
    'UBA': Color(0xFFD50032),
  };

  static const _bankOptions = [
    'GTBank',
    'FirstBank',
    'Ecobank',
    'Zenith Bank',
    'Access Bank',
    'UBA',
  ];

  @override
  void dispose() {
    _accountCtrl.dispose();
    super.dispose();
  }

  Color _bankColor(String bank) =>
      _bankColors[bank] ?? AppColors.primary;

  String _bankInitials(String bank) =>
      bank.length >= 2 ? bank.substring(0, 2).toUpperCase() : bank.toUpperCase();

  void _showBankPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select Bank',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ..._bankOptions.map((bank) => ListTile(
                title: Text(bank,
                    style: GoogleFonts.urbanist(
                        fontSize: 14, color: AppColors.textPrimary)),
                onTap: () {
                  setState(() => _selectedBank = bank);
                  Navigator.pop(ctx);
                },
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildGradientAppBar(
            context,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Linked Bank Accounts',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Manage your accounts',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _showAddForm ? _buildAddForm(bottomPad) : _buildAccountList(bottomPad),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountList(double bottomPad) {
    return Stack(
      children: [
        ListView.builder(
          padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPad + 80),
          itemCount: _accounts.length,
          itemBuilder: (ctx, i) {
            final acc = _accounts[i];
            final bankColor = _bankColor(acc['bank'] as String);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: bankColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _bankInitials(acc['bank'] as String),
                        style: GoogleFonts.urbanist(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          acc['number'] as String,
                          style: GoogleFonts.urbanist(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          acc['name'] as String,
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (acc['isDefault'] as bool) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Default',
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  GestureDetector(
                    onTap: () {
                      setState(() => _accounts.removeAt(i));
                    },
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFE53935),
                      size: 20,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: bottomPad + 16,
          left: 16,
          right: 16,
          child: _gradientButton(
            context: context,
            label: 'Add a new account',
            onTap: () => setState(() => _showAddForm = true),
          ),
        ),
      ],
    );
  }

  Widget _buildAddForm(double bottomPad) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 24, 16, bottomPad + 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fieldLabel('Select Bank'),
              GestureDetector(
                onTap: _showBankPicker,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedBank ?? 'Select your bank',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: _selectedBank != null
                                ? AppColors.textPrimary
                                : AppColors.textHint,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _fieldLabel('Enter account'),
              TextField(
                controller: _accountCtrl,
                keyboardType: TextInputType.number,
                style: GoogleFonts.urbanist(
                    fontSize: 14, color: AppColors.textPrimary),
                decoration:
                    _filledDecoration(hint: 'Enter your account number'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _setAsDefault,
                    onChanged: (v) =>
                        setState(() => _setAsDefault = v ?? false),
                    activeColor: AppColors.primary,
                  ),
                  Text(
                    'Set as default',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: bottomPad + 16,
          left: 16,
          right: 16,
          child: _gradientButton(
            context: context,
            label: 'Save Account',
            onTap: () {
              if (_selectedBank == null || _accountCtrl.text.isEmpty) return;
              setState(() {
                if (_setAsDefault) {
                  for (final acc in _accounts) {
                    acc['isDefault'] = false;
                  }
                }
                _accounts.add({
                  'bank': _selectedBank!,
                  'number': '${_accountCtrl.text.substring(0, _accountCtrl.text.length > 4 ? 4 : _accountCtrl.text.length)}******',
                  'name': 'Halima Fatokun',
                  'isDefault': _setAsDefault,
                });
                _showAddForm = false;
                _selectedBank = null;
                _accountCtrl.clear();
                _setAsDefault = true;
              });
            },
          ),
        ),
      ],
    );
  }
}

// ─── 7. DeleteAccountScreen ───────────────────────────────────────────────────

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  String? _selectedReason;
  final _otherCtrl = TextEditingController();

  static const _reasons = [
    'I no longer need the service',
    'I found a better platform',
    'Too many technical issues',
    'Privacy concerns',
    'Other',
  ];

  @override
  void dispose() {
    _otherCtrl.dispose();
    super.dispose();
  }

  void _showReasonPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select a Reason',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ..._reasons.map((r) => ListTile(
                title: Text(r,
                    style: GoogleFonts.urbanist(
                        fontSize: 14, color: AppColors.textPrimary)),
                onTap: () {
                  setState(() => _selectedReason = r);
                  Navigator.pop(ctx);
                },
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚠️', style: TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want delete',
              style: GoogleFonts.urbanist(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFB300)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  'Access to your active Bookings',
                  'Access to your account records and credentials',
                  'Login details',
                  'All Client contacts via message and call',
                ].map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.textSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item,
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _showDeleteSuccessSheet();
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          'Yes, Confirm',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          'Not Yet',
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteSuccessSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              size: 80,
              color: Color(0xFF4CAF50),
            ),
            const SizedBox(height: 16),
            Text(
              'Successful',
              style: GoogleFonts.urbanist(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your account has been deleted successfully. We\'re sorry to see you go and we hope to see you soon',
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _gradientButton(
              context: ctx,
              label: 'Close App',
              onTap: () {
                Navigator.pop(ctx);
                SystemNavigator.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthBloc>().state;
    final accountName = auth is AuthAuthenticated ? auth.user.name : 'Your account';
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildGradientAppBar(
            context,
            title: Center(
              child: Text(
                'Delete Account',
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFE53935), width: 2.5),
                      ),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 44,
                            child: ClipOval(
                              child: AppNetworkImage(
                                url: null,
                                width: 88,
                                height: 88,
                                fit: BoxFit.cover,
                                errorWidget: Container(
                                  width: 88,
                                  height: 88,
                                  color: AppColors.primaryLight,
                                  child: Center(
                                    child: Text(
                                      accountName.isNotEmpty
                                          ? accountName[0].toUpperCase()
                                          : 'V',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE53935),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.warning_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      accountName,
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Tell us the reason for deleting your account',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _showReasonPicker,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedReason ?? 'Select an Option',
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: _selectedReason != null
                                    ? AppColors.textPrimary
                                    : AppColors.textHint,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textHint,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Other Reasons',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _otherCtrl,
                    maxLines: 4,
                    style: GoogleFonts.urbanist(
                        fontSize: 14, color: AppColors.textPrimary),
                    decoration: _filledDecoration(hint: 'Type your message'),
                  ),
                  const SizedBox(height: 32),
                  _gradientButton(
                    context: context,
                    label: 'Deactivate Account',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Account deactivated',
                              style: GoogleFonts.urbanist(fontSize: 14)),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: GestureDetector(
                      onTap: _showDeleteConfirmDialog,
                      child: Text(
                        'Delete Account',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE53935),
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xFFE53935),
                        ),
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

// ─── 8. SubscriptionPlanScreen ────────────────────────────────────────────────

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  static const _callbackUrl = 'https://planovar.app/payment/complete';
  final _repo = SubscriptionRepository();

  List<SubscriptionPlanModel> _plans = [];
  String? _currentTier;
  String? _currentStatus;
  bool _loading = true;
  String? _error;
  String? _busyTier;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _repo.listPlans(),
        _repo.getMySubscription(),
      ]);
      final plans = results[0] as List<SubscriptionPlanModel>;
      final sub = results[1] as Map<String, dynamic>?;
      if (!mounted) return;
      setState(() {
        _plans = plans;
        final plan = sub?['plan'];
        _currentTier = (plan is Map ? plan['tier'] : sub?['tier'])?.toString();
        _currentStatus = sub?['status']?.toString();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loading = false;
      });
    }
  }

  Future<void> _changeTo(SubscriptionPlanModel plan) async {
    setState(() => _busyTier = plan.tier);
    try {
      final res = await _repo.changePlan(
        planId: plan.id,
        billingCycle: 'MONTHLY',
        callbackUrl: _callbackUrl,
      );
      final checkoutUrl = res['checkoutUrl'] as String?;
      final paymentRef = res['reference'] as String?;

      // Free plan (Basic) switches immediately; paid plans need payment.
      if (checkoutUrl == null || checkoutUrl.isEmpty || paymentRef == null) {
        if (!mounted) return;
        await _load();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You are now on the ${plan.name} plan')),
          );
        }
        return;
      }

      if (!mounted) return;
      final reference = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (_) => PaymentCheckoutScreen(
            checkoutUrl: checkoutUrl,
            reference: paymentRef,
          ),
        ),
      );

      if (reference == null) {
        // User closed checkout without paying — plan unchanged.
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment cancelled — your plan is unchanged')),
          );
        }
        return;
      }

      // Confirm payment, then activate.
      await _repo.verify(reference);
      if (!mounted) return;
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment confirmed — you are now on the ${plan.name} plan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _busyTier = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          _buildGradientAppBar(
            context,
            title: Center(
              child: Text(
                'Subscription Plan',
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_error!,
                                style: GoogleFonts.urbanist(
                                    color: AppColors.textSecondary)),
                            const SizedBox(height: 12),
                            AppButton.secondary('Retry', onTap: _load, width: 140),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                        children: [
                          Text(
                            'Choose the plan that fits your business. Upgrade or switch anytime.',
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._plans.map(_buildPlanCard),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlanModel plan) {
    final isCurrent = plan.tier == _currentTier;
    final busy = _busyTier == plan.tier;
    final limit = plan.listingLimit == null
        ? 'Unlimited listings'
        : plan.listingLimit == 0
            ? 'No listings'
            : '${plan.listingLimit} active listings';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent ? AppColors.primary : AppColors.border,
          width: isCurrent ? 1.6 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plan.name,
                  style: GoogleFonts.urbanist(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (isCurrent)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _currentStatus?.toUpperCase() == 'TRIALING'
                        ? 'On trial'
                        : 'Current',
                    style: GoogleFonts.urbanist(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            plan.isFree ? 'Free' : plan.priceLabel(),
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(limit,
                  style: GoogleFonts.urbanist(
                      fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          ...plan.features.take(4).map(
                (f) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(f,
                            style: GoogleFonts.urbanist(
                                fontSize: 13,
                                color: AppColors.textSecondary)),
                      ),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 14),
          if (isCurrent)
            AppButton.secondary('Current Plan', onTap: null)
          else
            AppButton.primary(
              plan.isFree ? 'Switch to ${plan.name}' : 'Upgrade to ${plan.name}',
              loading: busy,
              onTap: busy ? null : () => _changeTo(plan),
            ),
        ],
      ),
    );
  }
}

// ─── 9. HelpScreen ───────────────────────────────────────────────────────────

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.pop();
        context.push('/profile/support');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
