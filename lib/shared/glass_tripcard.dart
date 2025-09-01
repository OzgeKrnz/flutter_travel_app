import 'package:flutter/material.dart';
import 'glass_surface.dart';

class GlassTripCard extends StatelessWidget {
  final String title, subtitle, dateRange, category, imageUrl;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const GlassTripCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.dateRange,
    required this.category,
    required this.imageUrl,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      radius: 18,
      padding: EdgeInsets.zero, // kart kendi içinde padding verecek
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Görsel
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // İçerik
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.black.withOpacity(0.75))),
                const SizedBox(height: 6),
                Text(dateRange, style: TextStyle(color: Colors.black.withOpacity(0.65), fontSize: 12)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(category, style: const TextStyle(fontSize: 12)),
                    IconButton(
                      onPressed: onFavorite,
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
