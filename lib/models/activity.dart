import 'dart:convert';

import '../config.dart';
import '../data/categories.dart' as categories;

/// A catalogue item (activity or event) from the Marrakech Privée database.
///
/// Two origins are supported:
///  * [seed] data bundled in the app (used as an offline fallback) — an item
///    carries a local [asset] and gets `hasRemoteImage == false`.
///  * Supabase rows fetched via PostgREST — an item carries an [id] and the
///    full French content (title, description, address, map link, pricing,
///    duration, guest options). Images live in `image_url` as Base64 data-URIs
///    and are loaded lazily on the detail page (never in bulk lists).
class Activity {
  final String title;
  final String category;
  final String? subcategory;
  final String section; // 'activities' | 'events'
  final String city;
  final String description;

  /// Local bundled asset (seed data only), e.g. `'hotair_balloon.jpg'`.
  final String? asset;

  /// Absolute network URL or `data:image/...` data-URI (Supabase data only).
  final String? imageUrl;

  /// Every image of the activity as Base64 `data:image/...` URIs — loaded
  /// lazily on the detail page from the Supabase `images` column.
  final List<String> images;

  /// Used to keep list keys stable and to persist favourites / bucket list.
  final String? id;

  final String? descriptionFr;
  final String? address;
  final String? mapLink;
  final num? price;
  final num? vipPrice;
  final String? pricingModel;
  final String? bookingMode;
  final int? maxGuests;
  final String? durationUnit;
  final num? durationHours;
  final List<String> durationOptions;
  final List<String> guestOptions;
  final bool isVipOnly;

  const Activity._({
    required this.title,
    required this.category,
    required this.section,
    required this.city,
    required this.description,
    this.subcategory,
    this.asset,
    this.imageUrl,
    this.images = const [],
    this.id,
    this.descriptionFr,
    this.address,
    this.mapLink,
    this.price,
    this.vipPrice,
    this.pricingModel,
    this.bookingMode,
    this.maxGuests,
    this.durationUnit,
    this.durationHours,
    this.durationOptions = const [],
    this.guestOptions = const [],
    this.isVipOnly = false,
  });

  /// Bundled/seed item referencing a local asset.
  const Activity(this.title, this.category, this.asset, this.description)
      : subcategory = null,
        section = 'activities',
        city = 'Marrakech',
        imageUrl = null,
        images = const [],
        id = null,
        descriptionFr = null,
        address = null,
        mapLink = null,
        price = null,
        vipPrice = null,
        pricingModel = null,
        bookingMode = null,
        maxGuests = null,
        durationUnit = null,
        durationHours = null,
        durationOptions = const [],
        guestOptions = const [],
        isVipOnly = false;

  /// Bundled/seed item that belongs to the events section.
  const Activity.event(this.title, this.category, this.asset, this.description)
      : subcategory = null,
        section = 'events',
        city = 'Marrakech',
        imageUrl = null,
        images = const [],
        id = null,
        descriptionFr = null,
        address = null,
        mapLink = null,
        price = null,
        vipPrice = null,
        pricingModel = null,
        bookingMode = null,
        maxGuests = null,
        durationUnit = null,
        durationHours = null,
        durationOptions = const [],
        guestOptions = const [],
        isVipOnly = false;

  bool get hasRemoteImage => imageUrl != null && imageUrl!.isNotEmpty;

  String get displayImage => asset ?? imageUrl ?? '';

  bool get isEvent => section == 'events';

  String get categoryLabel => categories.categoryLabel(category);

  /// Human price: real prices are shown as-is, everything else is "Sur devis"
  /// (the whole current catalogue is quote-based).
  String get priceLabel {
    final raw = price;
    if (raw != null && raw > 0) {
      final digits = raw % 1 == 0 ? raw.toInt().toString() : raw.toString();
      return '$digits €';
    }
    return 'Sur devis';
  }

  /// Duration label like `2 h` or `3 jours`.
  String get durationLabel {
    final hours = durationHours;
    if (hours == null || hours <= 0) return '';
    if (durationUnit?.toUpperCase() == 'DAY') {
      final days = hours / 24;
      return days == days.floorToDouble() ? '${days.toInt()} jour${days > 1 ? 's' : ''}' : '${hours.round()} h';
    }
    return '$hours h';
  }

  /// Builds an [Activity] from a Supabase `activities` row.
  factory Activity.fromDb(Map<String, dynamic> row) {
    String read(String key) => (row[key] as String?)?.trim() ?? '';

    final titleFr = read('title_fr');
    final titleEn = read('title_en');
    final descFr = read('description_fr');
    final descEn = read('description_en');

    final sectionRaw = read('section').toLowerCase();
    final section = sectionRaw == 'evenement' || sectionRaw == 'events' ? 'events' : 'activities';

    return Activity._(
      id: read('id').isEmpty ? null : read('id'),
      title: [titleFr, titleEn, 'Sans titre'].firstWhere((v) => v.isNotEmpty),
      category: read('category').isEmpty ? 'activities' : read('category'),
      subcategory: read('subcategory').isEmpty ? null : read('subcategory'),
      section: section,
      city: read('city').isEmpty ? 'Marrakech' : read('city'),
      description: [descFr, descEn].firstWhere((v) => v.isNotEmpty),
      descriptionFr: descFr.isEmpty ? null : descFr,
      address: read('address').isEmpty ? null : read('address'),
      mapLink: read('map_link').isEmpty ? null : read('map_link'),
      price: _toNum(row['price']),
      vipPrice: _toNum(row['vip_price']),
      pricingModel: read('pricing_model').isEmpty ? null : read('pricing_model'),
      bookingMode: read('booking_mode').isEmpty ? null : read('booking_mode'),
      maxGuests: _toInt(row['max_guests']),
      durationUnit: read('duration_unit').isEmpty ? null : read('duration_unit'),
      durationHours: _toNum(row['duration_hours']),
      durationOptions: _toStringList(row['duration_options']),
      guestOptions: _toStringList(row['guest_options']),
      isVipOnly: row['is_vip_only'] == 1 || row['is_vip_only'] == true,
      imageUrl: null,
    );
  }

  bool get hasGallery => images.isNotEmpty;

  /// The website's per-activity image endpoint for image 0 — used as a light
  /// thumbnail on list cards until the full Base64 gallery is loaded.
  String? get remoteCoverUrl {
    if (id == null || id!.isEmpty) return null;
    return siteImageUrl(id!, 0);
  }

  /// Returns a copy with the full Base64 gallery loaded (detail page).
  Activity withImages(List<String> gallery) => Activity._(
        title: title,
        category: category,
        subcategory: subcategory,
        section: section,
        city: city,
        description: description,
        asset: asset,
        imageUrl: gallery.isEmpty ? imageUrl : gallery.first,
        images: gallery,
        id: id,
        descriptionFr: descriptionFr,
        address: address,
        mapLink: mapLink,
        price: price,
        vipPrice: vipPrice,
        pricingModel: pricingModel,
        bookingMode: bookingMode,
        maxGuests: maxGuests,
        durationUnit: durationUnit,
        durationHours: durationHours,
        durationOptions: durationOptions,
        guestOptions: guestOptions,
        isVipOnly: isVipOnly,
      );

  static num? _toNum(Object? value) => value is num
      ? value
      : value is String
          ? num.tryParse(value.trim()) ?? (int.tryParse(value.trim())?.toDouble())
          : null;

  static int? _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim()) ?? _toNum(value)?.toInt();
    return null;
  }

  static List<String> _toStringList(Object? value) {
    if (value == null) return const [];
    if (value is List) {
      return value.whereType<String>().map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    final text = value.toString().trim();
    if (text.isEmpty || text == 'null') return const [];
    try {
      final decoded = jsonDecode(text);
      if (decoded is List) return decoded.whereType<String>().map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    } catch (_) {
      // Not JSON — fall through to comma splitting.
    }
    return text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
}