import 'package:flutter/material.dart';

import '../features/about/about_sections.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'request_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  void _openRequest(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const RequestPage()));

  @override
  Widget build(BuildContext context) => PageFrame(
        title: 'À propos',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImageTile('About.png', 280),
            const SizedBox(height: 25),
            const Text('L’art de prendre soin.', style: TextStyle(fontSize: 32, color: espresso, fontWeight: FontWeight.w300)),
            const SizedBox(height: 15),
            const Text('Marrakech Privée est une conciergerie locale et une agence événementielle dédiée aux expériences rares, pensées avec discrétion et attention.', style: TextStyle(color: brown, fontSize: 15, height: 1.65)),
            const SizedBox(height: 24),
            const Marquee(),
            const InvitationSection(),
            ServicesSection(onSelect: () => _openRequest(context)),
            const ApproachSection(),
            const EditorialSection(),
            const ExperienceSection(),
            const TrustSection(),
            const FaqSection(),
            RequestSection(onRequest: () => _openRequest(context)),
          ],
        ),
      );
}