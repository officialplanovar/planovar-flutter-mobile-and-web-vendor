import 'package:flutter/material.dart';

/// The Planovar brand lockup (mark + wordmark + tagline).
///
/// Picks the light- or dark-background artwork automatically from the current
/// theme brightness, so it sits cleanly on whatever surface it's placed on.
/// Pass [dark] to force a variant (e.g. on a coloured hero that ignores theme).
class PlanovarLogo extends StatelessWidget {
  const PlanovarLogo({super.key, this.height, this.width, this.dark});

  /// Asset for light backgrounds (black wordmark).
  static const String _light = 'assets/images/logo/planovar_logo_light.png';

  /// Asset for dark backgrounds (white wordmark).
  static const String _dark = 'assets/images/logo/planovar_logo_dark.png';

  final double? height;
  final double? width;

  /// Force the dark-background variant. Null = follow theme brightness.
  final bool? dark;

  @override
  Widget build(BuildContext context) {
    final useDark = dark ?? Theme.of(context).brightness == Brightness.dark;
    return Image.asset(
      useDark ? _dark : _light,
      height: height,
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      // Source art is 1280×1280; decode small so it never hogs memory.
      cacheWidth: 720,
      errorBuilder: (context, error, stack) => SizedBox(
        height: height,
        width: width,
        child: const FittedBox(
          child: Text(
            'PLANOVAR',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2),
          ),
        ),
      ),
    );
  }
}
