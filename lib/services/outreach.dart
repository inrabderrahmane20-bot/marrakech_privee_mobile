import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../models/activity.dart';
import '../theme/app_theme.dart';

/// Opens the target app (WhatsApp, Instagram, Mail) with [message] already
/// written — the user only has to press send. Each launcher copies the message
/// to the clipboard as well, so it always survives apps that cannot pre-fill
/// (notably Instagram).
class Outreach {
  Outreach._();

  static String get _whatsappDigits =>
      whatsappNumber.replaceAll(RegExp(r'[^\d]'), '');

  static Future<void> _copy(String message, BuildContext context,
      {String? label}) async {
    await Clipboard.setData(ClipboardData(text: message));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${label ?? 'Message'} copié dans le presse-papiers.',
            style: const TextStyle(fontSize: 12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  static Future<void> _open(Uri uri, BuildContext context,
      {String? label}) async {
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible d’ouvrir${label == null ? '' : ' $label'} '
                '(application absente ?). Le message est dans le presse-papiers.'),
            backgroundColor: espresso,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) showPasteHint(context, label ?? '');
    }
  }

  /// WhatsApp → opens the chat with Marrakech Privée, message ready to send.
  static Future<void> whatsapp(BuildContext context, String message) async {
    final text = Uri.encodeComponent(message);
    final uri = Uri.parse('https://wa.me/$_whatsappDigits?text=$text');
    await _copy(message, context, label: 'Message WhatsApp');
    // ignore: use_build_context_synchronously
    await _open(uri, context, label: 'WhatsApp');
  }

  /// Instagram → opens the DM thread with the account; the message is copied
  /// (Meta does not let links pre-fill an Instagram message).
  static Future<void> instagram(BuildContext context, String message) async {
    await _copy(message, context, label: 'Message Instagram');
    // ignore: use_build_context_synchronously
    await _open(Uri.parse(instagramDmLink(message)), context, label: 'Instagram');
  }

  /// Mail → opens the favourite mail app with subject and body filled in.
  static Future<void> email(BuildContext context, String subject, String body) async {
    final uri = Uri(
      scheme: 'mailto',
      path: contactEmail,
      queryParameters: {'subject': subject, 'body': body},
    );
    await _open(uri, context, label: 'l’e-mail');
  }

  /// The public website link behind an activity page — used to share it.
  static String activityLink(Activity activity) {
    if (activity.id?.isNotEmpty == true) return activityWebsiteUrl(activity.id!);
    final slug = activity.title
        .toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9à-ÿ]+"), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return activityWebsiteUrl(slug.isEmpty ? 'marrakech' : slug);
  }

  /// Shares one activity via a system share sheet (any app the user wants).
  static Future<void> systemShare(BuildContext context, Activity activity) async {
    final link = activityLink(activity);
    await SharePlus.instance.share(
      ShareParams(
        text:
            'Découvre cette expérience Marrakech Privée — ${activity.title}\n$link',
      ),
    );
  }

  /// Copies the website link of the activity (kept ready to paste anywhere).
  static Future<void> copyLink(BuildContext context, Activity activity) async {
    await _copy(activityLink(activity), context, label: 'Lien');
  }

  /// Copies an arbitrary string (used for map links, etc.).
  static Future<void> copyRaw(BuildContext context, String text) async {
    await _copy(text, context);
  }
}

/// A brief dark snackbar used for paste-hints after launching an app.
void showPasteHint(BuildContext context, String label) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Message copié dans le presse-papiers — ouvrez $label pour le coller.',
        style: const TextStyle(fontSize: 12),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: espresso,
      behavior: SnackBarBehavior.floating,
    ),
  );
}