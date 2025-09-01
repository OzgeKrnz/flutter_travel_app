import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

String cityImageUrl(String city) =>
    'https://picsum.photos/seed/${Uri.encodeComponent(city)}/800/600';

Widget tripImage(String city) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: CachedNetworkImage(
      imageUrl: cityImageUrl(city),
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
      errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported),
    ),
  );
}
