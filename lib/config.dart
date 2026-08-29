/// Marrakech Privée — app-wide configuration.
///
/// The catalogue is read straight from the Supabase PostgREST API
/// (`$supabaseUrl/rest/v1/...`) using the public anon key — the same
/// database that powers the marrakech_privee.com website.
const String apiBaseUrl = 'https://www.marrakechprivee.com';

/// Supabase project hosting the `activities` and `collections` tables.
const String supabaseUrl = 'https://dkotbmrmygdwbppgdqdk.supabase.co';

/// Public anon key (safe to ship in the app; it only grants read access).
// TODO: paste the full anon key value (starts with
// `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRrb3RibXJteWdkd2JwcGdkcWRrIiwicm9sZSI6ImFub24i`).
// While this placeholder is incomplete the app automatically falls back to
// its bundled offline catalogue.
const String supabaseAnonKey = 'PASTE_SUPABASE_ANON_KEY_HERE';

/// WhatsApp destination used by the personalised request page
/// (matches the website's `/demande` submission).
const String whatsappNumber = '+212 6 23 94 12 20';
const String whatsappLink = 'https://wa.me/212623941220';
const String contactEmail = 'bonjour@marrakechprivee.com';