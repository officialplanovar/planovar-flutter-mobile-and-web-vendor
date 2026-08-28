import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/upload_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/vendor/data/vendor_repository.dart';
import '../../../shared/widgets/network_image_widget.dart';

// ─── Dashed border painter ────────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5756F5).withValues(alpha: 0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    const radius = 12.0;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(radius)));
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) => false;
}

// ─── GalleryScreen ────────────────────────────────────────────────────────────

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final List<String?> _images = List.filled(4, null);
  int? _uploadingIndex;
  bool _saving = false;

  static const _labels = [
    'Front Photo',
    'Second Photo',
    'Third Photo',
    'Fourth Photo',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final vendor = await VendorRepository().getMe();
      final urls = vendor?.portfolioUrls ?? const <String>[];
      if (!mounted) return;
      setState(() {
        for (var i = 0; i < _images.length && i < urls.length; i++) {
          _images[i] = urls[i];
        }
      });
    } catch (_) {/* keep empty slots */}
  }

  Future<void> _pickAndUpload(int index) async {
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked == null) return;
      setState(() => _uploadingIndex = index);
      final bytes = await picked.readAsBytes();
      final url = await UploadService().uploadListingImage(bytes, picked.name);
      if (mounted) setState(() => _images[index] = url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not upload photo: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadingIndex = null);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await VendorRepository().updateProfile({
        'portfolioUrls': _images.whereType<String>().toList(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gallery saved')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save gallery: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: context.c.background,
      body: Column(
        children: [
          // Gradient AppBar
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Gallery',
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Showcase your best work to attract clients',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.0,
                ),
                itemCount: 4,
                itemBuilder: (context, i) {
                  final hasImage = _images[i] != null;
                  final uploading = _uploadingIndex == i;
                  return GestureDetector(
                    onTap: uploading ? null : () => _pickAndUpload(i),
                    child: uploading
                        ? Container(
                            decoration: BoxDecoration(
                              color: context.c.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                                child: CircularProgressIndicator()),
                          )
                        : hasImage
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AppNetworkImage(
                              url: _images[i],
                              fit: BoxFit.cover,
                            ),
                          )
                        : CustomPaint(
                            painter: _DashedBorderPainter(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: context.c.surface,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.image_outlined,
                                      color: AppColors.primary,
                                      size: 28,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _labels[i],
                                      style: GoogleFonts.urbanist(
                                        fontSize: 13,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),
            ),
          ),

          // Save button
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPadding + 16),
            child: GestureDetector(
              onTap: _saving ? null : _save,
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
                    'Save Gallery',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
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
    );
  }
}
