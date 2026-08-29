import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../theme/app_theme.dart';
import 'activity_image.dart';
import 'favorite_button.dart';

class CatalogCard extends StatelessWidget {
  final Activity item;
  final VoidCallback onTap;
  const CatalogCard({required this.item, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cream,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x1A2E211C)),
            boxShadow: [
              BoxShadow(color: const Color(0x0F2E211C), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(borderRadius: BorderRadius.circular(14), child: ActivityImage(activity: item, width: 120, height: 120)),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: FavoriteButton(activity: item, iconSize: 15),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.categoryLabel.toUpperCase(), style: const TextStyle(color: coral, fontSize: 9, letterSpacing: 1.5)),
                    const SizedBox(height: 8),
                    Text(item.title, style: const TextStyle(color: espresso, fontSize: 19, height: 1.15, fontWeight: FontWeight.w300)),
                    const SizedBox(height: 12),
                    const Text('Sur devis  →', style: TextStyle(color: brown, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}