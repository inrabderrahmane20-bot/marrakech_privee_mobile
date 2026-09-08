/// Marrakech Privée — app-wide configuration.
///
/// The catalogue is read straight from the Supabase PostgREST API
/// (`$supabaseUrl/rest/v1/...`) using the public anon key — the same
/// database that powers the marrakech_privee.com website.
const String apiBaseUrl = 'https://www.marrakechprivee.com';

/// Supabase project hosting the `activities` and `collections` tables.
const String supabaseUrl = 'https://dkotbmrmygdwbppgdqdk.supabase.co';

/// Public anon key (safe to ship in the app; it only grants the same
/// read access as the marrakechprivee.com website).
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRrb3RibXJteWdkd2JwcGdkcWRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIzNzcwMzcsImV4cCI6MjA5Nzk1MzAzN30.oa2QGl8X5UAvkXgLizNA0-0gniYVLC4YexGixmv4R0g';

/// WhatsApp destination used by the personalised request page
/// (matches the website's `/demande` submission).
const String whatsappNumber = '+212 6 23 94 12 20';
const String whatsappLink = 'https://wa.me/212623941220';
const String contactEmail = 'bonjour@marrakechprivee.com';

/// Instagram account used by the request/contact flows.
const String instagramHandle = 'marrakech.privee';

/// Opens a direct-message thread with the Marrakech Privée Instagram account.
String instagramDmLink([String message = '']) =>
    'https://ig.me/m/$instagramHandle${message.isEmpty ? '' : '?text=${Uri.encodeQueryComponent(message)}'}';

/// The public website URL of an activity — used when sharing an experience
/// ("Partager" copies this link; the detail page derives it from the id).
String activityWebsiteUrl(String idOrSlug) =>
    'https://www.marrakechprivee.com/activities/$idOrSlug';

/// Website endpoint serving each activity image by index — the same images as
/// the Supabase `images` column, but one at a time and HTTP-cached. The app
/// uses it as a light thumbnail for list cards (image 0) and as a growing
/// target in the detail gallery while the Base64 gallery loads.
String siteImageUrl(String activityId, int index) =>
    'https://www.marrakechprivee.com/api/activities/$activityId/image?i=$index';