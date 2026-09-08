import 'package:flutter/material.dart';

import '../data/activity_repository.dart';
import '../models/activity.dart';
import '../theme/app_theme.dart';
import '../widgets/filter_sheets.dart';
import '../widgets/home_activity_card.dart';

/// The experiences (events) page — mirrors the activities page so it shares the
/// same features: a filter sheet, a sort / group control, a result count and
/// the full-width card layout.
class EventsPage extends StatefulWidget {
  final ValueChanged<Activity> onOpenActivity;
  const EventsPage({required this.onOpenActivity, super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String selectedCategory = 'all';
  String selectedSort = 'relevance';

  List<Activity> _filteredActivities(List<Activity> all) {
    final categoryMatches = selectedCategory == 'all'
        ? all
        : all.where((item) => item.category == selectedCategory).toList();

    final sorted = List<Activity>.from(categoryMatches);
    switch (selectedSort) {
      case 'az':
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'category':
        sorted.sort((a, b) => a.category.compareTo(b.category));
        break;
      case 'relevance':
      default:
        break;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final sortLabel = {
      'relevance': 'Pertinence',
      'az': 'A–Z',
      'category': 'Type',
    }[selectedSort] ?? 'Pertinence';

    return Scaffold(
      backgroundColor: blush,
      body: SafeArea(
        child: FutureBuilder<List<Activity>>(
          future: ActivityRepository.instance.events(),
          builder: (context, snapshot) {
            final source = snapshot.data ?? <Activity>[];
            final list = _filteredActivities(source);
            final loading = !snapshot.hasData;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Toolbar(
                  sortLabel: sortLabel,
                  onFilter: () => showFilterSheetFor(
                    context,
                    ActivityRepository.instance.events(),
                    selectedCategory,
                    (value) => setState(() => selectedCategory = value),
                  ),
                  onSort: () => showSortSheet(context, selectedSort, (value) => setState(() => selectedSort = value)),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Text(
                    '${list.length} expériences',
                    style: const TextStyle(color: espresso, fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: loading
                      ? const Center(child: CircularProgressIndicator(color: coral))
                      : list.isEmpty
                          ? const Center(child: Text('Aucune expérience ne correspond à ce filtre.', style: TextStyle(color: brown, fontSize: 15)))
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final item = list[index];
                                return HomeActivityCard(
                                  activity: item,
                                  extraLabel: selectedCategory == 'all' ? 'Toutes les expériences' : item.categoryLabel,
                                  onTap: () => widget.onOpenActivity(item),
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  final String sortLabel;
  final VoidCallback onFilter;
  final VoidCallback onSort;

  const _Toolbar({required this.sortLabel, required this.onFilter, required this.onSort});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: espresso, fontSize: 13, fontWeight: FontWeight.w600);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onFilter,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(14), border: Border.all(color: blushDeep)),
                child: const Row(
                  children: [
                    Icon(Icons.tune, color: coral, size: 18),
                    SizedBox(width: 8),
                    Flexible(child: Text('Filtres', maxLines: 1, overflow: TextOverflow.ellipsis, style: textStyle)),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down, color: brown, size: 20),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onSort,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(14), border: Border.all(color: blushDeep)),
                child: Row(
                  children: [
                    const Icon(Icons.sort, color: coral, size: 18),
                    const SizedBox(width: 8),
                    Flexible(child: Text('Trier par · $sortLabel', style: textStyle, overflow: TextOverflow.ellipsis)),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_down, color: brown, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
