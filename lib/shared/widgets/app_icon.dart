import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders a single-color SVG from `assets/icons/`, tinted to [color].
/// Usage: `AppIcon('send', size: 22, color: Colors.white)`.
class AppIcon extends StatelessWidget {
  final String name; // filename without path/extension, e.g. 'send'
  final double size;
  final Color? color;

  const AppIcon(this.name, {super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$name.svg',
      width: size,
      height: size,
      colorFilter:
          color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
