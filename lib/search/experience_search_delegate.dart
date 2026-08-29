import 'package:flutter/material.dart';

import '../data/activity_repository.dart';
import '../models/activity.dart';
import '../screens/detail/activity_detail_page.dart';
import '../theme/app_theme.dart';
import '../widgets/catalog_card.dart';

class ExperienceSearchDelegate extends SearchDelegate<Activity?> {
  @override
  List<Widget>? buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _results(context, ActivityRepository.instance.search(query));

  @override
  Widget buildSuggestions(BuildContext context) => _results(context, ActivityRepository.instance.search(query));

  Widget _results(BuildContext context, Future<List<Activity>> future) {
    return FutureBuilder<List<Activity>>(
      future: future,
      builder: (context, snapshot) {
        final matches = snapshot.data ?? <Activity>[];
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: coral));
        }
        if (matches.isEmpty) return const Center(child: Text('Aucune expérience trouvée.', style: TextStyle(color: brown)));
        return ListView(
          padding: const EdgeInsets.all(16),
          children: matches
              .map((item) => CatalogCard(
                    item: item,
                    onTap: () {
                      close(context, item);
                      Navigator.push(context, MaterialPageRoute<void>(builder: (_) => ActivityDetailPage(activity: item)));
                    },
                  ))
              .toList(),
        );
      },
    );
  }
}