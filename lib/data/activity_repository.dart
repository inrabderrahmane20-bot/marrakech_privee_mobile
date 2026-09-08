import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/activity.dart';
import 'activities.dart' as seed;

/// Fetches the catalogue straight from the Supabase PostgREST API
/// (`$supabaseUrl/rest/v1/activities`) — the same database that powers the
/// marrakech_privee.com website — and transparently falls back to the bundled
/// seed data whenever the database is unreachable or misconfigured.
///
/// BULK fetches never select the `images` / `image_url` columns (they are
/// multi-hundred-KB Base64 blobs per row). List cards instead load a light
/// thumbnail from the website's image endpoint; the detail page calls
/// [loadGallery] to pull the full Base64 image list for one activity lazily.
class ActivityRepository {
  ActivityRepository._();

  static final ActivityRepository instance = ActivityRepository._();

  Duration timeout = const Duration(seconds: 15);

  static const String _select =
      'id,category,section,subcategory,city,address,map_link,title_fr,title_en,title_es,'
      'description_fr,description_en,description_es,price,vip_price,pricing_model,'
      'booking_mode,max_guests,duration_unit,duration_hours,duration_options,'
      'guest_options,ask_region,is_vip_only,sort_order,tickets_available';

  List<Activity>? _catalogCache;
  Future<List<Activity>>? _inFlightFuture;
  final Map<String, Activity> _detailCache = {};

  Map<String, String> get _authHeaders => {
        'apikey': supabaseAnonKey,
        'Authorization': 'Bearer $supabaseAnonKey',
        'Accept': 'application/json',
      };

  /// The full catalogue (activities + events), fetched once then cached.
  Future<List<Activity>> catalog() {
    final cached = _catalogCache;
    if (cached != null) return Future.value(cached);
    if (_inFlightFuture != null) return _inFlightFuture!;

    final future = _fetchCatalog();
    _inFlightFuture = future;
    return future;
  }

  Future<List<Activity>> activities() async =>
      (await catalog()).where((a) => !a.isEvent).toList();

  Future<List<Activity>> events() async =>
      (await catalog()).where((a) => a.isEvent).toList();

  Future<List<Activity>> _fetchCatalog() async {
    try {
      final uri = Uri.parse(
        '$supabaseUrl/rest/v1/activities?select=$_select&limit=1000&order=sort_order',
      );
      final response = await http.get(uri, headers: _authHeaders).timeout(timeout);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          final list = decoded
              .whereType<Map<String, dynamic>>()
              .map(Activity.fromDb)
              .where((a) => a.title.isNotEmpty)
              .toList();
          if (list.isNotEmpty) {
            _catalogCache = list;
            return list;
          }
        }
      }
    } catch (_) {
      // Unreachable/invalid key/malformed response → bundled fallback below.
    }
    _catalogCache = [...seed.activities, ...seed.events];
    return _catalogCache!;
  }

  /// Loads every image of a single activity (the Supabase `images` column,
  /// an array of Base64 data-URIs). Already-loaded rows are served instantly.
  /// The call is safe to repeat; on failure the activity is returned unchanged
  /// and its card keeps the remote thumbnail.
  Future<Activity> loadGallery(Activity activity) async {
    final id = activity.id;
    if (id == null || id.isEmpty || activity.hasGallery) return activity;
    final cached = _detailCache[id];
    if (cached != null) return cached;
    try {
      final uri = Uri.parse('$supabaseUrl/rest/v1/activities?select=images&id=eq.$id&limit=1');
      final response = await http.get(uri, headers: _authHeaders).timeout(timeout);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List && decoded.isNotEmpty && decoded.first is Map<String, dynamic>) {
          final images = _parseImageList((decoded.first as Map<String, dynamic>)['images']);
          if (images.isNotEmpty) {
            final updated = activity.withImages(images);
            _detailCache[id] = updated;
            return updated;
          }
        }
      }
    } catch (_) {
      // Ignore — the carousel keeps the remote thumbnail.
    }
    return activity;
  }

  static List<String> _parseImageList(Object? value) {
    if (value == null) return const [];
    if (value is List) return value.whereType<String>().toList();
    final text = value.toString().trim();
    if (text.isEmpty) return const [];
    try {
      final decoded = jsonDecode(text);
      if (decoded is List) return decoded.whereType<String>().toList();
    } catch (_) {
      // Not JSON — not a usable gallery.
    }
    return const [];
  }

  /// Site-wide search over the fetched catalogue (title, description, city).
  ///
  /// An empty query returns the whole catalogue (activities + experiences) so
  /// the search page shows everything before the user types anything.
  Future<List<Activity>> search(String query) async {
    final all = await catalog();
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return all;
    return all
        .where((a) =>
            '${a.title} ${a.categoryLabel} ${a.city} ${a.description}'
                .toLowerCase()
                .contains(term))
        .toList();
  }
}