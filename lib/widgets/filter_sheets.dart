import 'package:flutter/material.dart';

import '../data/activity_repository.dart';
import '../data/categories.dart';
import '../theme/app_theme.dart';

/// Pop-up (modal bottom sheet) listing every available catalogue category so
/// the user can filter the home list by type.
Future<void> showFilterSheet(BuildContext context, String selected, ValueChanged<String> onCategorySelected) async {
  final all = await ActivityRepository.instance.activities();
  if (!context.mounted) return;
  final slugs = ['all', ...all.map((a) => a.category).where((c) => c.isNotEmpty).toSet()]..sort();
  final chosen = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: cream,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
    builder: (context) => _PickerSheet<String>(
      title: 'Filtres',
      items: slugs,
      selected: selected,
      labelOf: (value) => value == 'all' ? 'Toutes les catégories' : categoryLabel(value),
      onChanged: (value) => Navigator.pop(context, value),
    ),
  );
  if (chosen != null) onCategorySelected(chosen);
}

/// Pop-up (modal bottom sheet) letting the user pick how the home list is
/// grouped / sorted.
Future<void> showSortSheet(BuildContext context, String selected, ValueChanged<String> onSortSelected) async {
  const options = {
    'relevance': 'Pertinence',
    'az': 'A–Z',
    'category': 'Type',
  };
  final chosen = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: cream,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
    builder: (context) => _PickerSheet<String>(
      title: 'Trier par',
      items: options.keys.toList(),
      selected: selected,
      labelOf: (value) => options[value] ?? value,
      onChanged: (value) => Navigator.pop(context, value),
    ),
  );
  if (chosen != null) onSortSelected(chosen);
}

class _PickerSheet<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T selected;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  const _PickerSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 38, height: 4, decoration: BoxDecoration(color: blushDeep, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 18),
            Text(title, style: const TextStyle(color: espresso, fontSize: 24, fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = item == selected;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(labelOf(item), style: TextStyle(color: espresso, fontSize: 15, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: coral, size: 20) : null,
                    onTap: () => onChanged(item),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}