import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

class SiteHeader extends StatelessWidget {
  const SiteHeader({super.key});

  @override
  Widget build(BuildContext context) => Container(
        color: blush.withValues(alpha: .92),
        padding: const EdgeInsets.fromLTRB(18, 14, 14, 12),
        child: Row(
          children: [
            Image.asset('assets/Looogo_t.webp', width: 24, height: 28, fit: BoxFit.contain),
            const SizedBox(width: 10),
            const Text('MARRAKECH PRIVÉE', style: TextStyle(color: espresso, fontSize: 12, letterSpacing: 1.8, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class HeroSection extends StatelessWidget {
  final VoidCallback onRequest;
  final VoidCallback onViewServices;
  const HeroSection({required this.onRequest, required this.onViewServices, super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(23, 25, 23, 0),
        child: Column(
          children: [
            const Eyebrow('SUR INVITATION  ·  MARRAKECH & MAROC'),
            const SizedBox(height: 19),
            const Text('Conciergerie de\nluxe &\névénements\nd’exception à\nMarrakech.', textAlign: TextAlign.center, style: TextStyle(fontSize: 37, height: 1.02, fontWeight: FontWeight.w300, color: espresso)),
            const SizedBox(height: 18),
            const Text('Conciergerie privée et agence événementielle basée à Marrakech, événements sur mesure, services VIP et séjours inoubliables partout au Maroc. Dites-nous ce que vous avez en tête, nous nous occupons de tout le reste.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5, height: 1.7, color: brown)),
            const SizedBox(height: 24),
            PillButton(label: '◉  Démarrer ma demande', onPressed: onRequest),
            TextButton(onPressed: onViewServices, child: const Text('Voir nos prestations', style: TextStyle(color: brown, fontSize: 12))),
            const SizedBox(height: 18),
            SizedBox(
              height: 230,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipPath(clipper: ArchClipper(), child: Image.asset('assets/homepage1.webp', width: 184, height: 230, fit: BoxFit.cover)),
                  Positioned(
                    left: 12,
                    bottom: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(padding: const EdgeInsets.all(4), color: blush, child: Image.asset('assets/homepage2.webp', width: 105, height: 80, fit: BoxFit.cover)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            const Text('+200', style: TextStyle(fontSize: 29, color: coral, fontWeight: FontWeight.w300)),
            const Text('séjours et événements privés organisés\nen toute discrétion', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: brown, height: 1.45)),
            const SizedBox(height: 25),
          ],
        ),
      );
}

class ArchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..addRRect(RRect.fromRectAndCorners(Rect.fromLTWH(0, 0, size.width, size.height), topLeft: Radius.circular(size.width / 2), topRight: Radius.circular(size.width / 2)));
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class VenueSection extends StatelessWidget {
  const VenueSection({super.key});

  @override
  Widget build(BuildContext context) => SectionShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImageTile('private_villa_pool_morocco_lounge_sunset.jpg', 320),
            const SizedBox(height: 27),
            const Eyebrow('LIEUX D’EXCEPTION'),
            const SizedBox(height: 14),
            const Text('Des adresses qui\nouvrent un autre Maroc.', style: TextStyle(fontSize: 30, height: 1.04, color: espresso, fontWeight: FontWeight.w300)),
            const SizedBox(height: 14),
            const Text('Villas privées, riads confidentiels et lieux choisis pour leur âme, leur service et leur capacité à devenir le décor de votre histoire.', style: TextStyle(color: brown, fontSize: 14, height: 1.65)),
          ],
        ),
      );
}

class QuoteSection extends StatelessWidget {
  const QuoteSection({super.key});

  @override
  Widget build(BuildContext context) => const SectionShell(
        child: Column(
          children: [
            Rule(),
            SizedBox(height: 25),
            Text('« Le luxe, c’est l’attention portée à ce que les autres ne voient pas. »', textAlign: TextAlign.center, style: TextStyle(fontSize: 25, height: 1.25, color: espresso, fontStyle: FontStyle.italic, fontWeight: FontWeight.w300)),
            SizedBox(height: 18),
            Text('MARRAKECH PRIVÉE', style: TextStyle(color: coral, fontSize: 10, letterSpacing: 2)),
          ],
        ),
      );
}