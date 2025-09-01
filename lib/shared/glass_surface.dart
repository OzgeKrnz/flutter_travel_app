import 'dart:ui';
import 'package:flutter/material.dart';

class GlassSurface extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  final double sigma;
  final double opacity;    
  final bool elevate;       

  const GlassSurface({
    super.key,
    required this.child,
    this.radius = 24,
    this.padding = const EdgeInsets.all(12),
    this.sigma = 16,
    this.opacity = 0.28,
    this.elevate = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(opacity + 0.27),
                Colors.white.withOpacity(opacity),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: elevate
                ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 12))]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
