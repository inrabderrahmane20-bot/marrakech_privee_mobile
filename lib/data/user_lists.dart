import 'package:flutter/foundation.dart';

import '../models/activity.dart';

/// In-memory user lists.
///
/// * **Favorites** — `♥` tapped on any card. Lives on `Mes favoris`.
/// * **Bucket list** — during an event / experience planning. Lives on
///   `Ma bucket list`.
///
/// Both lists store stable activity keys (`id`, or the seed `title` when
/// offline). Persistence across app restarts can be added with a storage
/// plugin (`shared_preferences`) once Maven Central is reachable from this
/// build machine — the store is deliberately plugin-free so the app still
/// compiles offline.
class UserLists extends ChangeNotifier {
  UserLists._();

  static final UserLists instance = UserLists._();

  final Set<String> _favorites = <String>{};
  final Set<String> _bucket = <String>{};
  bool _loaded = false;

  static String keyOf(Activity activity) =>
      (activity.id?.isNotEmpty ?? false) ? activity.id! : activity.title;

  /// Safe to call repeatedly; keeps the API stable for future persistence.
  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;
    notifyListeners();
  }

  bool isFavorite(Activity activity) => _favorites.contains(keyOf(activity));

  bool isBucket(Activity activity) => _bucket.contains(keyOf(activity));

  void toggleFavorite(Activity activity) {
    final key = keyOf(activity);
    _favorites.contains(key) ? _favorites.remove(key) : _favorites.add(key);
    notifyListeners();
  }

  void toggleBucket(Activity activity) {
    final key = keyOf(activity);
    _bucket.contains(key) ? _bucket.remove(key) : _bucket.add(key);
    notifyListeners();
  }
}