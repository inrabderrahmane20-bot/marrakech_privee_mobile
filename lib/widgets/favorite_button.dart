import 'package:flutter/material.dart';

import '../data/user_lists.dart';
import '../models/activity.dart';
import '../theme/app_theme.dart';

/// Circular heart toggle shown on cards and the detail page, backed by
/// [UserLists] (favorites).
class FavoriteButton extends StatelessWidget {
  final Activity activity;
  final double iconSize;

  const FavoriteButton({super.key, required this.activity, this.iconSize = 17});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserLists.instance,
      builder: (context, _) {
        final active = UserLists.instance.isFavorite(activity);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => UserLists.instance.toggleFavorite(activity),
            customBorder: const CircleBorder(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Icon(
                active ? Icons.favorite : Icons.favorite_border,
                size: iconSize,
                color: active ? coral : brown,
              ),
            ),
          ),
        );
      },
    );
  }
}