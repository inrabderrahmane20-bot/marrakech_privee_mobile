import 'package:flutter/material.dart';

import '../data/activity_repository.dart';
import '../data/categories.dart';
import '../models/activity.dart';
import '../theme/app_theme.dart';
import '../widgets/catalog_card.dart';
import '../widgets/common.dart';

class CatalogPage extends StatefulWidget {
  final String title;
  final String intro;

  /// The catalogue section to display: 'activities' or 'events'.
  final String section;
  final ValueChanged<Activity> onOpen;
  const CatalogPage({
    required this.title,
    required this.intro,
    required this.section,
    required this.onOpen,
    super.key,
  });

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String selectedCategory = 'Tout';

  Future<List<Activity>> get _itemsFuture => widget.section == 'events'
      ? ActivityRepository.instance.events()
      : ActivityRepository.instance.activities();

  @override
  Widget build(BuildContext context) {
    return PageFrame(
      title: widget.title,
      child: FutureBuilder<List<Activity>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          final items = snapshot.data ?? <Activity>[];
          final categories = ['Tout', ...items.map((item) => item.category).toSet()];
          final visibleItems = selectedCategory == 'Tout' ? items : items.where((item) => item.category == selectedCategory).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.intro, style: const TextStyle(color: brown, fontSize: 14, height: 1.6)),
              const SizedBox(height: 22),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    final category = categories[index];
                    return ChoiceChip(
                      label: Text(category == 'Tout' ? 'Tout' : categoryLabel(category)),
                      selected: selectedCategory == category,
                      onSelected: (_) => setState(() => selectedCategory = category),
                      selectedColor: coral,
                      backgroundColor: cream,
                      labelStyle: TextStyle(color: selectedCategory == category ? cream : brown, fontSize: 11),
                      side: BorderSide.none,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              if (!snapshot.hasData)
                const Padding(padding: EdgeInsets.symmetric(vertical: 35), child: Center(child: CircularProgressIndicator(color: coral)))
              else if (visibleItems.isEmpty)
                const Padding(padding: EdgeInsets.symmetric(vertical: 35), child: Center(child: Text('Aucune expérience dans cette catégorie.', style: TextStyle(color: brown))))
              else
                ...visibleItems.map((item) => CatalogCard(item: item, onTap: () => widget.onOpen(item))),
            ],
          );
        },
      ),
    );
  }
}