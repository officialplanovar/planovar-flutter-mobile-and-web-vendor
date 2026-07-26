import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/router/app_routes.dart';
import '../data/auth_repository.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../setup/bloc/setup_cubit.dart';
import '../../vendor/data/vendor_repository.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _businessNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  DateTime? _dob;
  bool _obscurePassword = true;
  bool _agreed = false;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  String _fmtDobDisplay(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';
  String _fmtDobSend(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 25),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 13), // 13+ minimum age
      helpText: 'Select your date of birth',
    );
    if (picked != null) setState(() => _dob = picked);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _businessNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: context.c.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: context.c.textHint,
            ),
          ),
        ),
        Expanded(child: Divider(color: context.c.border)),
      ],
    );
  }

  Widget _buildGoogleButton(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _googleSignIn(context),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: context.c.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.c.border, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/google_logo.svg',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Continue with Google',
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: context.c.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _googleSignIn(BuildContext context) async {
    try {
      await AuthRepository().signInWithGoogle();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.c.surface,
      appBar: AppBar(
        backgroundColor: context.c.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: context.c.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: pagePadding(context, base: 24).add(const EdgeInsets.only(top: 8, bottom: 40)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create your vendor account',
              style: GoogleFonts.urbanist(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: context.c.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Start listing your business on Planovar',
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: context.c.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // First & last name of the contact person behind the business
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppInput(
                    label: 'First Name',
                    hint: 'e.g. Ada',
                    controller: _firstNameCtrl,
                    keyboardType: TextInputType.name,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppInput(
                    label: 'Last Name',
                    hint: 'e.g. Obi',
                    controller: _lastNameCtrl,
                    keyboardType: TextInputType.name,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Business Name
            AppInput(
              label: 'Business Name',
              hint: 'e.g. Sugared Dreams Cakery',
              controller: _businessNameCtrl,
            ),
            const SizedBox(height: 16),

            // Date of Birth
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date of Birth',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.c.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: _pickDob,
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: context.c.surfaceElevated,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _dob == null
                                ? 'DD / MM / YYYY'
                                : _fmtDobDisplay(_dob!),
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              color: _dob == null
                                  ? context.c.textHint
                                  : context.c.textPrimary,
                            ),
                          ),
                        ),
                        Icon(Icons.calendar_today_outlined,
                            size: 18, color: context.c.textSecondary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Email
            AppInput(
              label: 'Email Address',
              hint: 'yourname@business.com',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Phone with Nigeria prefix
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone Number',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.c.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: context.c.surfaceElevated,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '🇳🇬',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '+234',
                            style: GoogleFonts.urbanist(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: context.c.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppInput(
                        hint: '8012345678',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Password
            AppInput(
              label: 'Create Password',
              hint: 'Min 8 characters',
              controller: _passwordCtrl,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: context.c.textHint,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 20),

            // Terms checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _agreed,
                    onChanged: (v) => setState(() => _agreed = v ?? false),
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: context.c.textSecondary,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                            text: 'By checking the box you agree to our '),
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            height: 1.5,
                          ),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Next button — creates the account + sends email OTP, then advances
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthOtpSent) {
                  // Type this brand-new account as a vendor (vendor-app sign-up)
                  // so the role gate admits it. Fire-and-forget.
                  VendorRepository().claimIntent().catchError((_) {});
                  context.push(
                    AppRoutes.verifyEmail,
                    extra: {'email': _emailCtrl.text.trim()},
                  );
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                final loading = state is AuthLoading;
                return AppButton.primary(
                  'Next',
                  loading: loading,
                  onTap: (_agreed && !loading)
                      ? () {
                          // Strip a leading national-trunk 0 so 08012345678 and
                          // 8012345678 both become +2348012345678.
                          final phone = _phoneCtrl.text
                              .trim()
                              .replaceAll(RegExp(r'^0+'), '');
                          // Carry the business name into the setup flow so it
                          // reaches onboard (the setup steps don't re-collect it).
                          context
                              .read<SetupCubit>()
                              .setBusinessName(_businessNameCtrl.text.trim());
                          context.read<AuthBloc>().add(
                                AuthSignUpRequested(
                                  firstName: _firstNameCtrl.text.trim(),
                                  lastName: _lastNameCtrl.text.trim(),
                                  dateOfBirth:
                                      _dob == null ? null : _fmtDobSend(_dob!),
                                  businessName: _businessNameCtrl.text.trim(),
                                  email: _emailCtrl.text.trim(),
                                  password: _passwordCtrl.text,
                                  phone: phone.isEmpty ? null : '+234$phone',
                                ),
                              );
                        }
                      : null,
                );
              },
            ),
            const SizedBox(height: 20),

            _buildDivider(context),
            const SizedBox(height: 20),

            _buildGoogleButton(context),
            const SizedBox(height: 28),

            // Sign in link — Wrap so it never overflows on narrow screens.
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: context.c.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.login),
                  child: Text(
                    'Sign in',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
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
}
