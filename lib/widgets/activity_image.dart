import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/activity.dart';

/// Decodes (and caches) the Base64 `data:image/...` URIs stored in the
/// Supabase `activities.image_url` column so they render as [MemoryImage]s.
class DataUriImageCache {
  DataUriImageCache._();

  static final Map<String, MemoryImage> _cache = {};

  static MemoryImage? memoryImage(String dataUri) {
    final cached = _cache[dataUri];
    if (cached != null) return cached;
    try {
      final comma = dataUri.indexOf(',');
      if (comma <= 0 || !dataUri.startsWith('data:image/')) return null;
      var base64Data = dataUri.substring(comma + 1).replaceAll(RegExp(r'\s'), '');
      final remainder = base64Data.length % 4;
      if (remainder != 0) base64Data = base64Data.padRight(base64Data.length + 4 - remainder, '=');
      final image = MemoryImage(base64Decode(base64Data));
      _cache[dataUri] = image;
      return image;
    } catch (_) {
      return null;
    }
  }
}

/// Renders an [Activity]'s cover image, choosing between the Base64 data-URI
/// (loaded Supabase gallery), the website's per-activity image endpoint (light
/// thumbnail for list cards), the bundled local asset, or a neutral
/// placeholder when none of them are available.
class ActivityImage extends StatelessWidget {
  final Activity activity;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ActivityImage({
    super.key,
    required this.activity,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = activity.imageUrl;
    if (imageUrl != null && imageUrl.startsWith('data:image/')) {
      final memoryImage = DataUriImageCache.memoryImage(imageUrl);
      if (memoryImage != null) {
        return Image(
          image: memoryImage,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, _, _) => _placeholder(),
        );
      }
    }
    // Supabase rows in lists have no Base64 blob yet: fall back to the
    // website's per-activity image endpoint (lazy, HTTP-cached thumbnail).
    final remote = imageUrl ?? activity.remoteCoverUrl;
    if (remote != null && remote.isNotEmpty) {
      return Image.network(
        remote,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    final asset = activity.asset;
    if (asset != null && asset.isNotEmpty) {
      return Image.asset(
        'assets/$asset',
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: const Color(0xFFE8E0D6),
        child: const Icon(Icons.image_not_supported_outlined, color: Color(0xFF9B6B4A)),
      );
}