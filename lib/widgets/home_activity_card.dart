import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../theme/app_theme.dart';
import 'activity_image.dart';
import 'favorite_button.dart';

/// A full-width card for a single activity — used in the home list
/// (activities shown one after the other).
class HomeActivityCard extends StatelessWidget {
  final Activity activity;
  final String extraLabel;
  final VoidCallback onTap;

  const HomeActivityCard({
    super.key,
    required this.activity,
    required this.extraLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: blush,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: blushDeep),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ActivityImage(activity: activity, width: 84, height: 84),
                  ),
                  Positioned(
                    top: 3,
                    right: 3,
                    child: FavoriteButton(activity: activity, iconSize: 13),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activity.title, style: const TextStyle(color: espresso, fontSize: 15, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(extraLabel, style: const TextStyle(color: brown, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      runSpacing: 2,
                      children: [
                        Icon(Icons.location_on, size: 12, color: brown),
                        Text(activity.city.isEmpty ? 'Marrakech, Maroc' : activity.city, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: brown, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(activity.priceLabel, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: coral, fontSize: 12)),
                        ),
                        const Icon(Icons.arrow_forward, size: 14, color: brown),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}