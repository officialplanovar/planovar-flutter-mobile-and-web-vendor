import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/services/upload_service.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/models/subscription_plan_model.dart';
import '../../listings/data/listings_repository.dart';
import '../../subscription/data/subscription_repository.dart';
import '../bloc/setup_cubit.dart';
import 'payment_checkout_screen.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

// ─── Shared Setup Widgets ────────────────────────────────────────────────────

class _SetupProgressBar extends StatelessWidget {
  final int step;
  final int total;

  const _SetupProgressBar({required this.step, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      color: AppColors.primaryLight,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: step / total,
        child: Container(color: AppColors.primary),
      ),
    );
  }
}

class _SetupHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SetupHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: GoogleFonts.urbanist(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

PreferredSizeWidget _buildSetupAppBar(
  BuildContext context, {
  required int step,
  required int total,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_rounded,
          color: AppColors.textPrimary),
      onPressed: () => context.pop(),
    ),
    title: Text(
      'Business Setup',
      style: GoogleFonts.urbanist(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),
    centerTitle: true,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(4),
      child: _SetupProgressBar(step: step, total: total),
    ),
  );
}

// ─── Step 1: Business Type ────────────────────────────────────────────────────

class SetupBusinessTypeScreen extends StatefulWidget {
  const SetupBusinessTypeScreen({super.key});

  @override
  State<SetupBusinessTypeScreen> createState() =>
      _SetupBusinessTypeScreenState();
}

class _SetupBusinessTypeScreenState extends State<SetupBusinessTypeScreen> {
  String? _selected;

  Widget _buildTypeCard({
    required String value,
    required String label,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selected == value;
    return GestureDetector(
      onTap: () => setState(() => _selected = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.divider,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
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
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 22),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSetupAppBar(context, step: 1, total: 6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SetupHeader(
                title: 'Business profile',
                subtitle: 'Tell clients who you are',
              ),
              const SizedBox(height: 32),
              _buildTypeCard(
                value: 'licensed',
                label: 'Licensed Business',
                subtitle: 'Registered company, agency or studio',
                icon: Icons.verified_rounded,
              ),
              const SizedBox(height: 16),
              _buildTypeCard(
                value: 'freelancer',
                label: 'Freelancer',
                subtitle: 'Individual offering professional services',
                icon: Icons.person_rounded,
              ),
              const Spacer(),
              AppButton.primary(
                'Proceed',
                onTap: _selected != null
                    ? () {
                        context.read<SetupCubit>().setBusinessType(_selected!);
                        context.push(AppRoutes.setupProfile);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Step 2: Business Profile ─────────────────────────────────────────────────

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final _descCtrl = TextEditingController();
  final Set<String> _selectedTags = {};
  final _uploads = UploadService();
  final _picker = ImagePicker();

  // Categories from the backend.
  List<CategoryOption> _categories = const [];
  bool _loadingCats = true;
  String? _catsError;

  // Business logo upload state.
  String? _logoUrl;
  bool _uploadingLogo = false;

  // Proof-of-ownership upload state.
  String? _proofUrl;
  String? _proofName;
  bool _uploadingProof = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _loadingCats = true;
      _catsError = null;
    });
    try {
      final cats = await ListingsRepository().categories();
      if (!mounted) return;
      setState(() {
        _categories = cats;
        _loadingCats = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _catsError = 'Could not load categories';
        _loadingCats = false;
      });
    }
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickLogo() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() => _uploadingLogo = true);
      final bytes = await picked.readAsBytes();
      final url = await _uploads.uploadVendorLogo(bytes, picked.name);
      if (!mounted) return;
      setState(() {
        _logoUrl = url;
        _uploadingLogo = false;
      });
    } catch (e) {
      if (mounted) setState(() => _uploadingLogo = false);
      _toast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _pickProof() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
        withData: true, // needed on web; also gives us bytes on mobile
      );
      if (result == null || result.files.isEmpty) return;
      final f = result.files.first;
      final bytes = f.bytes;
      if (bytes == null) {
        _toast('Could not read the selected file');
        return;
      }
      if (bytes.length > 5 * 1024 * 1024) {
        _toast('File is larger than 5 MB');
        return;
      }
      setState(() => _uploadingProof = true);
      final url = await _uploads.uploadDocument(bytes, f.name);
      if (!mounted) return;
      setState(() {
        _proofUrl = url;
        _proofName = f.name;
        _uploadingProof = false;
      });
    } catch (e) {
      if (mounted) setState(() => _uploadingProof = false);
      _toast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSetupAppBar(context, step: 2, total: 6),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SetupHeader(
                      title: 'Business profile',
                      subtitle: 'Tell clients who you are',
                    ),
                    const SizedBox(height: 28),

                    // Logo upload
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _uploadingLogo ? null : _pickLogo,
                            child: Container(
                              width: 100,
                              height: 100,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryLight,
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 1.5,
                                  style: BorderStyle.solid,
                                ),
                                image: (_logoUrl != null && !_uploadingLogo)
                                    ? DecorationImage(
                                        image: NetworkImage(_logoUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _uploadingLogo
                                  ? const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    )
                                  : (_logoUrl == null
                                      ? const Icon(
                                          Icons.camera_alt_outlined,
                                          color: AppColors.primary,
                                          size: 32,
                                        )
                                      : null),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Business logo (optional)',
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description
                    AppInput(
                      label: 'Business Description',
                      hint:
                          'Tell clients what makes your business special, your experience, and what you offer...',
                      controller: _descCtrl,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                    const SizedBox(height: 20),

                    // Proof of ownership
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Proof of Ownership',
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '(optional for freelancers)',
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _uploadingProof ? null : _pickProof,
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              color: _proofUrl != null
                                  ? AppColors.primaryLight
                                  : AppColors.divider,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _proofUrl != null
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _uploadingProof
                                  ? const [
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ]
                                  : _proofUrl != null
                                      ? [
                                          const Icon(
                                            Icons.check_circle_outline_rounded,
                                            color: AppColors.primary,
                                            size: 32,
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: Text(
                                              _proofName ?? 'Document uploaded',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.urbanist(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Tap to replace',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ]
                                      : [
                                          const Icon(
                                            Icons.upload_file_outlined,
                                            color: AppColors.textHint,
                                            size: 32,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Tap to upload',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'JPG, PNG or PDF up to 5mb',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: AppColors.textHint,
                                            ),
                                          ),
                                        ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Category tags
                    Text(
                      'Category tags',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_loadingCats)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.primary),
                        ),
                      )
                    else if (_catsError != null)
                      Row(
                        children: [
                          Text(
                            _catsError!,
                            style: GoogleFonts.urbanist(
                                fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _loadCategories,
                            child: Text(
                              'Retry',
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      )
                    else if (_categories.isEmpty)
                      Text(
                        'No categories available yet',
                        style: GoogleFonts.urbanist(
                            fontSize: 13, color: AppColors.textHint),
                      )
                    else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _categories.map((cat) {
                        final tag = cat.name;
                        final isSelected = _selectedTags.contains(tag);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedTags.remove(tag);
                              } else {
                                _selectedTags.add(tag);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.urbanist(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: AppButton.primary(
                'Proceed',
                onTap: () {
                  final desc = _descCtrl.text.trim();
                  context.read<SetupCubit>().setProfile(
                        description: desc.isEmpty ? null : desc,
                        tags: _selectedTags,
                        logoUrl: _logoUrl,
                        proofUrl: _proofUrl,
                      );
                  context.push(AppRoutes.setupLocation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 3: Location ─────────────────────────────────────────────────────────

const _nigerianCities = [
  'Lagos',
  'Abuja',
  'Port Harcourt',
  'Ibadan',
  'Kano',
  'Enugu',
  'Warri',
  'Benin City',
  'Owerri',
  'Calabar',
];

class SetupLocationScreen extends StatefulWidget {
  const SetupLocationScreen({super.key});

  @override
  State<SetupLocationScreen> createState() => _SetupLocationScreenState();
}

class _SetupLocationScreenState extends State<SetupLocationScreen> {
  String _country = 'Nigeria';
  String? _city;
  String _vendorType = 'both';

  void _showCountryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Select Country',
          style: GoogleFonts.urbanist(
              fontSize: 17, fontWeight: FontWeight.w700),
        ),
        content: ListTile(
          title: Text('Nigeria',
              style: GoogleFonts.urbanist(fontSize: 15)),
          leading: const Text('🇳🇬', style: TextStyle(fontSize: 20)),
          trailing: const Icon(Icons.check_rounded,
              color: AppColors.primary, size: 20),
          onTap: () {
            setState(() => _country = 'Nigeria');
            Navigator.pop(ctx);
          },
        ),
      ),
    );
  }

  void _showCitySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Text(
              'Select City',
              style: GoogleFonts.urbanist(
                  fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _nigerianCities.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.divider),
              itemBuilder: (ctx2, i) {
                final city = _nigerianCities[i];
                final isSelected = _city == city;
                return ListTile(
                  title: Text(city,
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      )),
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _city = city);
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String displayValue,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayValue,
                    style: GoogleFonts.urbanist(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textHint),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioTile(String value, String label) {
    return GestureDetector(
      onTap: () => setState(() => _vendorType = value),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _vendorType,
              onChanged: (v) => setState(() => _vendorType = v!),
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.urbanist(
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSetupAppBar(context, step: 3, total: 6),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SetupHeader(
                      title: 'Location & reach',
                      subtitle: 'Where do you operate?',
                    ),
                    const SizedBox(height: 28),

                    _buildDropdownField(
                      label: 'Country',
                      displayValue: _country,
                      onTap: _showCountryDialog,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'City',
                      displayValue: _city ?? 'Select your city',
                      onTap: _showCitySheet,
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(color: AppColors.border)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: GoogleFonts.urbanist(
                                fontSize: 13, color: AppColors.textHint),
                          ),
                        ),
                        const Expanded(
                            child: Divider(color: AppColors.border)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Use current location
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.my_location_rounded,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Use my current location',
                              style: GoogleFonts.urbanist(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    Text(
                      'Vendor type',
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildRadioTile('products', 'Products Only'),
                    _buildRadioTile('services', 'Services only'),
                    _buildRadioTile(
                        'both', 'Both products & services'),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: AppButton.primary(
                'Proceed',
                onTap: () {
                  context.read<SetupCubit>().setLocation(
                        country: _country,
                        city: _city,
                        vendorType: _vendorType,
                      );
                  context.push(AppRoutes.setupPlan);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 4: Plan ─────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final List<String> features;
  final bool isPopular;
  final bool isPrimary;
  final String ctaLabel;
  final VoidCallback onSelect;

  const _PlanCard({
    required this.name,
    required this.price,
    required this.features,
    required this.ctaLabel,
    required this.onSelect,
    this.isPopular = false,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPopular ? AppColors.primary : AppColors.border,
          width: isPopular ? 2 : 1.5,
        ),
        boxShadow: isPopular
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Center(
                child: Text(
                  'POPULAR',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: GoogleFonts.urbanist(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                ...features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_rounded,
                            color: AppColors.success, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            f,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: isPrimary
                      ? AppButton.primary(ctaLabel, onTap: onSelect)
                      : AppButton.secondary(ctaLabel, onTap: onSelect),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SetupPlanScreen extends StatefulWidget {
  const SetupPlanScreen({super.key});

  @override
  State<SetupPlanScreen> createState() => _SetupPlanScreenState();
}

class _SetupPlanScreenState extends State<SetupPlanScreen> {
  final _subscriptions = SubscriptionRepository();
  late Future<List<SubscriptionPlanModel>> _plansFuture;

  @override
  void initState() {
    super.initState();
    _plansFuture = _subscriptions.listPlans();
  }

  // Plan selection is carried in SetupCubit; subscribe runs at submit (KYC step).
  void _selectPlan(SubscriptionPlanModel plan) {
    context.read<SetupCubit>().setPlan(plan.id);
    context.push(AppRoutes.setupKyc);
  }

  void _skip() {
    context.read<SetupCubit>().setPlan(null); // stays on Basic
    context.push(AppRoutes.setupKyc);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSetupAppBar(context, step: 4, total: 6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SetupHeader(
                title: 'Choose your plan',
                subtitle: 'Upgrade anytime. Cancel anytime.',
              ),
              const SizedBox(height: 28),
              FutureBuilder<List<SubscriptionPlanModel>>(
                future: _plansFuture,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snap.hasError || !snap.hasData) {
                    return Column(
                      children: [
                        Text(
                          'Could not load plans. Check your connection and try again.',
                          style: GoogleFonts.urbanist(
                            fontSize: 14, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        AppButton.secondary('Retry',
                            onTap: () => setState(
                                () => _plansFuture = _subscriptions.listPlans())),
                      ],
                    );
                  }
                  final plans = snap.data!;
                  return Column(
                    children: [
                      for (final plan in plans) ...[
                        _PlanCard(
                          name: plan.name,
                          price: plan.priceLabel(),
                          features: plan.features,
                          ctaLabel: 'Select ${plan.name}',
                          isPopular: plan.tier == 'PREMIUM',
                          isPrimary: plan.tier == 'PREMIUM',
                          onSelect: () => _selectPlan(plan),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  );
                },
              ),
              const SizedBox(height: 4),
              Center(
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    'Skip for now',
                    style: GoogleFonts.urbanist(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Step 5: KYC / Verify identity ─────────────────────────────────────────────

class SetupKycScreen extends StatefulWidget {
  const SetupKycScreen({super.key});

  @override
  State<SetupKycScreen> createState() => _SetupKycScreenState();
}

class _SetupKycScreenState extends State<SetupKycScreen> {
  final _uploads = UploadService();

  String? _ninUrl, _ninName;
  bool _uploadingNin = false;
  String? _cacUrl, _cacName;
  bool _uploadingCac = false;

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickDoc({required bool isNin}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;
      final f = result.files.first;
      final bytes = f.bytes;
      if (bytes == null) {
        _toast('Could not read the selected file');
        return;
      }
      if (bytes.length > 5 * 1024 * 1024) {
        _toast('File is larger than 5 MB');
        return;
      }
      setState(() => isNin ? _uploadingNin = true : _uploadingCac = true);
      final url = await _uploads.uploadDocument(bytes, f.name);
      if (!mounted) return;
      setState(() {
        if (isNin) {
          _ninUrl = url;
          _ninName = f.name;
          _uploadingNin = false;
        } else {
          _cacUrl = url;
          _cacName = f.name;
          _uploadingCac = false;
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _uploadingNin = false;
          _uploadingCac = false;
        });
      }
      _toast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Widget _uploadBox({
    required String label,
    required String? url,
    required String? name,
    required bool uploading,
    required VoidCallback onTap,
  }) {
    final done = url != null;
    return GestureDetector(
      onTap: uploading ? null : onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        height: 110,
        decoration: BoxDecoration(
          color: done ? AppColors.primaryLight : AppColors.divider,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: done ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: uploading
              ? const [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primary),
                  ),
                ]
              : done
                  ? [
                      const Icon(Icons.check_circle_outline_rounded,
                          color: AppColors.primary, size: 30),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          name ?? 'Uploaded',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                      ),
                      Text('Tap to replace',
                          style: GoogleFonts.urbanist(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ]
                  : [
                      const Icon(Icons.upload_file_outlined,
                          color: AppColors.textHint, size: 30),
                      const SizedBox(height: 8),
                      Text(label,
                          style: GoogleFonts.urbanist(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary)),
                      Text('JPG, PNG or PDF up to 5mb',
                          style: GoogleFonts.urbanist(
                              fontSize: 12, color: AppColors.textHint)),
                    ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSetupAppBar(context, step: 5, total: 6),
      body: SafeArea(
        child: BlocConsumer<SetupCubit, SetupState>(
          listener: (context, state) async {
            if (state.status == SetupStatus.success) {
              // Paid plans return a Paystack checkout URL — collect payment in an
              // in-app WebView before finishing. (Basic returns none.)
              final url = state.checkoutUrl;
              final payRef = state.paymentReference;
              if (url != null && url.isNotEmpty && payRef != null) {
                final reference = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (_) => PaymentCheckoutScreen(
                      checkoutUrl: url,
                      reference: payRef,
                    ),
                  ),
                );
                if (!context.mounted) return;
                if (reference != null) {
                  try {
                    await context.read<SetupCubit>().verifyPayment(reference);
                  } catch (_) {/* surfaced below if not active */}
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Payment not completed — you can subscribe to a paid plan anytime from your profile.'),
                    ),
                  );
                }
              }
              if (context.mounted) context.go(AppRoutes.setupSuccess);
            } else if (state.status == SetupStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error ?? 'Something went wrong')),
              );
            }
          },
          builder: (context, state) {
            final submitting = state.status == SetupStatus.submitting;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SetupHeader(
                          title: 'Verify your identity',
                          subtitle:
                              'Upload your NIN, and CAC if you run a licensed business. Stored securely.',
                        ),
                        const SizedBox(height: 28),
                        _uploadBox(
                          label: 'Upload your NIN slip',
                          url: _ninUrl,
                          name: _ninName,
                          uploading: _uploadingNin,
                          onTap: () => _pickDoc(isNin: true),
                        ),
                        _uploadBox(
                          label: 'Upload your CAC document',
                          url: _cacUrl,
                          name: _cacName,
                          uploading: _uploadingCac,
                          onTap: () => _pickDoc(isNin: false),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  child: Column(
                    children: [
                      AppButton.primary(
                        submitting ? 'Setting up…' : 'Finish setup',
                        onTap: submitting
                            ? null
                            : () {
                                final auth = context.read<AuthBloc>().state;
                                final name = auth is AuthAuthenticated
                                    ? auth.user.name
                                    : '';
                                final cubit = context.read<SetupCubit>();
                                // Keep the proof captured on the profile step if
                                // no CAC was uploaded here.
                                cubit.setKyc(
                                  ninUrl: _ninUrl,
                                  cacUrl: _cacUrl ?? cubit.cacUrl,
                                );
                                cubit.submit(businessName: name);
                              },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You can complete verification later from your profile.',
                        style: GoogleFonts.urbanist(
                            fontSize: 12, color: AppColors.textHint),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Step 5 (legacy, unused under subscription-only): Payout ────────────────────

const _nigerianBanks = [
  'Zenith Bank',
  'GTBank',
  'Access Bank',
  'First Bank',
  'UBA',
  'Sterling Bank',
  'Fidelity Bank',
  'Polaris Bank',
  'Wema Bank',
  'Stanbic IBTC',
];

class SetupPayoutScreen extends StatefulWidget {
  const SetupPayoutScreen({super.key});

  @override
  State<SetupPayoutScreen> createState() => _SetupPayoutScreenState();
}

class _SetupPayoutScreenState extends State<SetupPayoutScreen> {
  String? _selectedBank;
  final _accountNumberCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _accountNumberCtrl.dispose();
    super.dispose();
  }

  void _showBankSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(4)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Text(
              'Select Bank',
              style: GoogleFonts.urbanist(
                  fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _nigerianBanks.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.divider),
              itemBuilder: (ctx2, i) {
                final bank = _nigerianBanks[i];
                final isSelected = _selectedBank == bank;
                return ListTile(
                  title: Text(bank,
                      style: GoogleFonts.urbanist(
                        fontSize: 15,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      )),
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedBank = bank);
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _saveAndContinue() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('vendor_isLoggedIn', true);
    if (mounted) {
      setState(() => _loading = false);
      context.go(AppRoutes.setupSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildSetupAppBar(context, step: 5, total: 6),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SetupHeader(
                      title: 'Payout details',
                      subtitle: 'Where should we send your earnings?',
                    ),
                    const SizedBox(height: 28),

                    // Bank name dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bank name',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: _showBankSheet,
                          child: Container(
                            height: 52,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedBank ?? 'Select your bank',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 15,
                                      color: _selectedBank != null
                                          ? AppColors.textPrimary
                                          : AppColors.textHint,
                                    ),
                                  ),
                                ),
                                const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.textHint),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Account number
                    AppInput(
                      label: 'Account number',
                      hint: '0123456789',
                      controller: _accountNumberCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Account name (read-only)
                    AppInput(
                      label: 'Account name',
                      hint: 'Auto verified',
                      readOnly: true,
                      enabled: false,
                    ),
                    const SizedBox(height: 20),

                    // Payout info box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F7FB),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payout schedule',
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _payoutRow(Icons.schedule_rounded,
                              'Rolling · 24–48hrs after completion'),
                          const SizedBox(height: 8),
                          _payoutRow(Icons.percent_rounded,
                              'Platform commission · Deducted before payout'),
                          const SizedBox(height: 8),
                          _payoutRow(Icons.account_balance_wallet_rounded,
                              'Minimum payout · ₦1,000'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Paystack badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shield_rounded,
                            color: AppColors.success, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Secured by Paystack',
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: AppButton.primary(
                'Save Payout Details',
                loading: _loading,
                onTap: _loading ? null : _saveAndContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _payoutRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Step 6: Success ──────────────────────────────────────────────────────────

class SetupSuccessScreen extends StatelessWidget {
  const SetupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 40),
          child: Column(
            children: [
              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
              const SizedBox(height: 28),

              Text(
                "You're all set!",
                style: GoogleFonts.urbanist(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Your vendor profile is live on Planovar. Start adding your products and services to reach thousands of event planners in Lagos.',
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Action cards
              _ActionCard(
                icon: Icons.add_business_rounded,
                title: 'Add your first listing',
                subtitle: 'Products, services or rentals',
                onTap: () => context.go(AppRoutes.listings),
              ),
              const SizedBox(height: 12),
              _ActionCard(
                icon: Icons.workspace_premium_rounded,
                title: 'Upgrade your plan',
                subtitle: 'Get more visibility & analytics',
                onTap: () => context.go(AppRoutes.listings),
              ),
              const SizedBox(height: 40),

              AppButton.primary(
                'Go to Dashboard',
                onTap: () => context.go(AppRoutes.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 14),
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
            const Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.textHint, size: 16),
          ],
        ),
      ),
    );
  }
}
