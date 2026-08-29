import 'package:flutter/material.dart';

import '../screens/about_page.dart';
import '../screens/contact_page.dart';
import '../screens/favorites_page.dart';
import '../screens/guide_page.dart';
import '../screens/request_page.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class AppDrawer extends StatelessWidget {
  final ValueChanged<int> onSelect;
  const AppDrawer({required this.onSelect, super.key});

  void _push(BuildContext context, Widget page) {
    final nav = Navigator.of(context);
    nav.pop();
    nav.push(MaterialPageRoute<void>(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: cream,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
            children: [
              Image.asset('assets/Logo_text_t.png', height: 34, alignment: Alignment.centerLeft),
              const SizedBox(height: 36),
              const Eyebrow('MARRAKECH PRIVÉE'),
              const SizedBox(height: 15),
              DrawerLink(icon: Icons.home_outlined, label: 'Accueil', onTap: () => onSelect(0)),
              DrawerLink(icon: Icons.event_outlined, label: 'Événements', onTap: () => onSelect(1)),
              const Divider(height: 38, color: Color(0x336B5248)),
              DrawerLink(icon: Icons.edit_note_outlined, label: 'Démarrer une demande', onTap: () => _push(context, const RequestPage())),
              DrawerLink(icon: Icons.menu_book_outlined, label: 'Guide de voyage', onTap: () => _push(context, const GuidePage())),
              DrawerLink(icon: Icons.mail_outline, label: 'Contact', onTap: () => _push(context, const ContactPage())),
              const Divider(height: 38, color: Color(0x336B5248)),
              DrawerLink(icon: Icons.favorite_border, label: 'Mes favoris', onTap: () => _push(context, const FavoritesPage())),
              DrawerLink(icon: Icons.bookmark_border, label: 'Ma bucket list', onTap: () => _push(context, const BucketPage())),
              const Divider(height: 38, color: Color(0x336B5248)),
              DrawerLink(icon: Icons.info_outline, label: 'À propos', onTap: () => _push(context, const AboutPage())),
            ],
          ),
        ),
      );
}

class DrawerLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const DrawerLink({required this.icon, required this.label, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: brown, size: 20),
        title: Text(label, style: const TextStyle(color: espresso, fontSize: 16)),
        onTap: onTap,
      );
}