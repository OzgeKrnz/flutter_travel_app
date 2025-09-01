import 'package:flutter/material.dart';
import 'glass_surface.dart';

class GlassTile extends StatelessWidget {
  final IconData icon;
  final double radius;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const GlassTile({
    super.key,
    this.radius = 24,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: GlassSurface(
          radius: 18,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          opacity: active ? 0.55 : 0.28,
          elevate: active,
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: Colors.black87),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
