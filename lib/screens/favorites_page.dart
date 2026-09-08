import 'package:flutter/material.dart';

import '../data/activity_repository.dart';
import '../data/user_lists.dart';
import '../models/activity.dart';
import '../screens/detail/activity_detail_page.dart';
import '../screens/request_page.dart';
import '../theme/app_theme.dart';
import '../widgets/catalog_card.dart';
import '../widgets/common.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) => _ListedPage(
        title: 'Mes favoris',
        icon: Icons.favorite_border,
        emptyText: 'Vos expériences préférées apparaîtront ici.',
        filter: (activity) => UserLists.instance.isFavorite(activity),
      );
}

class BucketPage extends StatelessWidget {
  const BucketPage({super.key});

  @override
  Widget build(BuildContext context) => _ListedPage(
        title: 'Ma bucket list',
        icon: Icons.bookmark_border,
        emptyText: 'Cette page regroupe les expériences à réserver pour votre séjour ou votre événement.',
        filter: (activity) => UserLists.instance.isBucket(activity),
        confirmLabel: 'Confirmer ma bucket list',
        confirmHint: 'Ajoutez ici vos dates, vos coordonnées et le nombre de personnes : le tout sera envoyé directement par WhatsApp, e-mail ou Instagram, prêt à être envoyé.',
      );
}

class _ListedPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final String emptyText;
  final bool Function(Activity) filter;
  final String? confirmLabel;
  final String? confirmHint;

  const _ListedPage({
    required this.title,
    required this.icon,
    required this.emptyText,
    required this.filter,
    this.confirmLabel,
    this.confirmHint,
  });

  @override
  Widget build(BuildContext context) => PageFrame(
        title: title,
        child: FutureBuilder<List<Activity>>(
          future: ActivityRepository.instance.catalog(),
          builder: (context, snapshot) {
            final all = snapshot.data ?? <Activity>[];
            return ListenableBuilder(
              listenable: UserLists.instance,
              builder: (context, _) {
                final items = all.where(filter).toList();
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator(color: coral)),
                  );
                }
                if (items.isEmpty) {
                  return Column(
                    children: [
                      const SizedBox(height: 35),
                      Icon(icon, color: coral, size: 42),
                      const SizedBox(height: 15),
                      Text(emptyText, textAlign: TextAlign.center, style: const TextStyle(color: brown, fontSize: 15)),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...items
                        .map((item) => CatalogCard(
                              item: item,
                              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ActivityDetailPage(activity: item))),
                            )),
                    if (confirmLabel != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cream,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: blushDeep),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (confirmHint != null) ...[
                              Text(
                                confirmHint!,
                                style: const TextStyle(color: brown, fontSize: 13, height: 1.5),
                              ),
                              const SizedBox(height: 14),
                            ],
                            SizedBox(
                              width: double.infinity,
                              child: PillButton(
                                label: confirmLabel!,
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => RequestPage(bucketItems: items),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            );
          },
        ),
      );
}