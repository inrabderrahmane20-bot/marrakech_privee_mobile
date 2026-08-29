/// French display labels for activity/event categories.
///
/// Slugs come from the Supabase `collections` table (the same categories the
/// website lists) plus the legacy seed-data types used when offline.
const Map<String, String> categoryLabelsBySlug = {
  // Supabase collections (activity section).
  'activities': 'Activités et services',
  'wellness': 'Bien-être',
  'ticketing': 'Billetterie',
  'restaurant': 'Restaurant',
  'services': 'Services',
  'transport': 'Transport',
  'tourisme': 'Tourisme',
  'day-pass': 'Day pass',
  // Supabase collections (events section).
  'animation': 'Animations',
  'beauty': 'Beauté',
  'decorator': 'Décoration & scénographie',
  'venue': 'Lieux de réception',
  'rental': 'Location de matériel',
  'music': 'Musique',
  'photography': 'Photographie',
  'caterer': 'Service traiteur',
  // Legacy seed-data types.
  'quad-buggy': 'Quad & buggy',
  'hot-air-balloon': 'Montgolfière',
  'agafay-desert': 'Désert d’Agafay',
  'desert': 'Sahara',
  'rooftop': 'Rooftop',
  'wellness-spa': 'Wellness & spa',
  'atlas-mountains': 'Atlas',
  'camel-rides': 'Dromadaire',
  'cultural-tours': 'Culture & visites',
  'fine-dining': 'Dîner gastronomique',
  'luxury-transport': 'Transport VIP',
  'nightlife': 'Nightlife',
  'weddings': 'Mariages',
  'vip-events': 'Événements privés',
  'corporate': 'Corporate',
};

/// Resolves a category slug to its French label, falling back to the slug.
String categoryLabel(String slug) => categoryLabelsBySlug[slug] ?? slug;