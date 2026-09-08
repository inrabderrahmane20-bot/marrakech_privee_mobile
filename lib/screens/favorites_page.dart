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

class _ListedPage extends StatefulWidget {
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
  State<_ListedPage> createState() => _ListedPageState();
}

class _ListedPageState extends State<_ListedPage> {
  List<Activity>? _catalog;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final all = await ActivityRepository.instance.catalog();
    if (mounted) setState(() => _catalog = all);
  }

  void _openConfirm(List<Activity> items) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => RequestPage(bucketItems: items)),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: UserLists.instance,
        builder: (context, _) {
          final all = _catalog ?? const <Activity>[];
          final items = all.where(widget.filter).toList();
          final loading = _catalog == null;

          final Widget body;
          if (loading) {
            body = const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator(color: coral)),
            );
          } else if (items.isEmpty) {
            body = Column(
              children: [
                const SizedBox(height: 35),
                Icon(widget.icon, color: coral, size: 42),
                const SizedBox(height: 15),
                Text(widget.emptyText, textAlign: TextAlign.center, style: const TextStyle(color: brown, fontSize: 15)),
              ],
            );
          } else {
            body = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items
                  .map((item) => CatalogCard(
                        item: item,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => ActivityDetailPage(activity: item)),
                        ),
                      ))
                  .toList(),
            );
          }

          return PageFrame(
            title: widget.title,
            bottomBar: widget.confirmLabel != null && items.isNotEmpty
                ? _ConfirmBar(
                    hint: widget.confirmHint,
                    label: widget.confirmLabel!,
                    onConfirm: () => _openConfirm(items),
                  )
                : null,
            child: body,
          );
        },
      );
}

class _ConfirmBar extends StatelessWidget {
  final String? hint;
  final String label;
  final VoidCallback onConfirm;

  const _ConfirmBar({required this.hint, required this.label, required this.onConfirm});

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: cream,
          border: Border(top: BorderSide(color: blushDeep)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(23, 12, 23, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (hint != null) ...[
                  Text(hint!, style: const TextStyle(color: brown, fontSize: 12, height: 1.45)),
                  const SizedBox(height: 10),
                ],
                PillButton(label: label, onPressed: onConfirm),
              ],
            ),
          ),
        ),
      );
}