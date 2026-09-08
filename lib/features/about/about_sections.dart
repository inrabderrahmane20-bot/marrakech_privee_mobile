import 'package:flutter/material.dart';

import '../../data/activity_repository.dart';
import '../../models/activity.dart';
import '../../theme/app_theme.dart';
import '../../widgets/catalog_card.dart';
import '../../widgets/common.dart';

class Marquee extends StatefulWidget {
  const Marquee({super.key});

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  static const String _tagline =
      'Conciergerie privée  ·  Des lieux d’exception  ·  Dîners dans le désert  ·  Mariages  ·  Transport VIP  ·  Expériences confidentielles';
  static const TextStyle _style = TextStyle(color: cream, fontSize: 15, fontStyle: FontStyle.italic);
  static const double _gap = 46;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final family = DefaultTextStyle.of(context).style.fontFamily;
    final painter = TextPainter(
      text: TextSpan(
        text: _tagline,
        style: TextStyle(color: cream, fontSize: 15, fontStyle: FontStyle.italic, fontFamily: family),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    final textWidth = painter.width;

    return Container(
      color: espresso,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: ClipRect(
        child: LayoutBuilder(
          builder: (_, _) => AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final offset = -_controller.value * (textWidth + _gap);
              return Stack(
                children: [
                  Transform.translate(offset: Offset(offset, 0), child: child),
                  Positioned(left: offset + textWidth + _gap, top: 0, child: child!),
                ],
              );
            },
            child: const Text(
              _tagline,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.clip,
              style: _style,
            ),
          ),
        ),
      ),
    );
  }
}

class InvitationSection extends StatelessWidget {
  const InvitationSection({super.key});

  @override
  Widget build(BuildContext context) => const SectionShell(
        child: Column(
          children: [
            Rule(),
            SizedBox(height: 22),
            Eyebrow('UNE ADRESSE CONFIDENTIELLE'),
            SizedBox(height: 17),
            Text('Le Maroc,\nà votre manière.', textAlign: TextAlign.center, style: TextStyle(fontSize: 31, height: 1.03, color: espresso, fontWeight: FontWeight.w300)),
            SizedBox(height: 18),
            Text('Une conciergerie privée pour celles et ceux qui recherchent plus qu’un séjour : une attention rare, des rencontres justes et des moments impossibles à reproduire.', textAlign: TextAlign.center, style: TextStyle(color: brown, fontSize: 14, height: 1.65)),
          ],
        ),
      );
}

class ServicesSection extends StatelessWidget {
  final VoidCallback onSelect;
  const ServicesSection({required this.onSelect, super.key});

  @override
  Widget build(BuildContext context) => Container(
        color: espresso,
        padding: const EdgeInsets.fromLTRB(23, 54, 23, 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('NOTRE SAVOIR-FAIRE', color: blushDeep),
            const SizedBox(height: 14),
            const Text('Tout commence\npar une intention.', style: TextStyle(color: cream, fontSize: 32, height: 1.05, fontWeight: FontWeight.w300)),
            const SizedBox(height: 13),
            const Text('Des expériences pensées dans les moindres détails, avec un interlocuteur unique et dédié.', style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.6)),
            const SizedBox(height: 28),
            ...['01  Séjours sur mesure', '02  Événements privés', '03  Expériences exclusives', '04  Services VIP'].map(
              (item) => InkWell(
                onTap: onSelect,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0x33F4EEE6)))),
                  child: Row(
                    children: [
                      Expanded(child: Text(item, style: const TextStyle(color: cream, fontSize: 17, fontWeight: FontWeight.w300))),
                      const Icon(Icons.arrow_forward, color: blushDeep, size: 17),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class ApproachSection extends StatelessWidget {
  const ApproachSection({super.key});

  @override
  Widget build(BuildContext context) => const SectionShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow('NOTRE APPROCHE'),
            SizedBox(height: 15),
            Text('Une attention\nqui ne se voit pas.', style: TextStyle(fontSize: 31, height: 1.04, color: espresso, fontWeight: FontWeight.w300)),
            SizedBox(height: 15),
            Text('Vous imaginez. Nous orchestrons. Chaque demande est traitée avec discrétion, précision et une vraie connaissance du territoire.', style: TextStyle(color: brown, fontSize: 14, height: 1.65)),
            SizedBox(height: 30),
            StepRow('01', 'Écouter', 'Comprendre vos envies, même celles que vous n’avez pas encore formulées.'),
            StepRow('02', 'Composer', 'Créer un itinéraire et des moments qui vous ressemblent.'),
            StepRow('03', 'Prendre soin', 'Être là avant, pendant et après, jusque dans les détails invisibles.'),
          ],
        ),
      );
}

class EditorialSection extends StatelessWidget {
  final VoidCallback? onOpenEvents;
  const EditorialSection({this.onOpenEvents, super.key});

  @override
  Widget build(BuildContext context) => SectionShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImageTile('luxury_wedding_decor_riad_marrakech_candles.jpg', 320),
            const SizedBox(height: 27),
            const Eyebrow('ÉVÉNEMENTS D’EXCEPTION'),
            const SizedBox(height: 14),
            const Text('Des célébrations\nqui deviennent des souvenirs.', style: TextStyle(fontSize: 30, height: 1.04, color: espresso, fontWeight: FontWeight.w300)),
            const SizedBox(height: 14),
            const Text('Mariages, dîners privés, lancements et événements d’entreprise : nous créons des instants qui ne ressemblent qu’à vous.', style: TextStyle(color: brown, fontSize: 14, height: 1.65)),
            const SizedBox(height: 20),
            TextButton(onPressed: onOpenEvents, child: const Text('Découvrir nos événements  →', style: TextStyle(color: coral, fontSize: 12))),
          ],
        ),
      );
}

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) => const SectionShell(
        child: Column(
          children: [
            Eyebrow('EXPÉRIENCES CONFIDENTIELLES'),
            SizedBox(height: 14),
            Text('Des souvenirs\nà vivre pleinement.', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, height: 1.05, color: espresso, fontWeight: FontWeight.w300)),
            SizedBox(height: 25),
            ExperienceTile('merzouga_dunes_golden_hour.jpg', 'Le désert autrement'),
            ExperienceTile('hotair_balloon.jpg', 'Au-dessus de Marrakech'),
            ExperienceTile('Hammam_Traditional_interiors.jpg', 'Rituels de bien-être'),
          ],
        ),
      );
}

class TrustSection extends StatelessWidget {
  const TrustSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
        color: cream,
        padding: const EdgeInsets.fromLTRB(23, 55, 23, 58),
        child: const Column(
          children: [
            Eyebrow('LA MAISON MARRAKECH PRIVÉE'),
            SizedBox(height: 14),
            Text('Une relation fondée\nsur la confiance.', textAlign: TextAlign.center, style: TextStyle(fontSize: 30, height: 1.05, color: espresso, fontWeight: FontWeight.w300)),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: Stat('+200', 'projets')),
                Expanded(child: Stat('4', 'langues')),
                Expanded(child: Stat('24/7', 'attention')),
              ],
            ),
          ],
        ),
      );
}

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) => const SectionShell(
        child: Column(
          children: [
            Rule(),
            SizedBox(height: 22),
            Eyebrow('QUESTIONS FRÉQUENTES'),
            SizedBox(height: 14),
            Text('Avant de commencer.', style: TextStyle(fontSize: 29, color: espresso, fontWeight: FontWeight.w300)),
            SizedBox(height: 20),
            FaqRow('Comment réserver une expérience ?'),
            FaqRow('Travaillez-vous partout au Maroc ?'),
            FaqRow('Quel est le délai de réponse ?'),
          ],
        ),
      );
}

class RequestSection extends StatelessWidget {
  final VoidCallback onRequest;
  const RequestSection({required this.onRequest, super.key});

  @override
  Widget build(BuildContext context) => Container(
        color: espresso,
        padding: const EdgeInsets.fromLTRB(23, 56, 23, 58),
        child: Column(
          children: [
            const Text('Dites-nous ce que\nvous avez en tête.', textAlign: TextAlign.center, style: TextStyle(color: cream, fontSize: 32, height: 1.04, fontWeight: FontWeight.w300)),
            const SizedBox(height: 15),
            const Text('Nous nous occupons de tout le reste.', style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 25),
            PillButton(label: 'Démarrer ma demande', onPressed: onRequest),
          ],
        ),
      );
}

class HomeActivitiesSection extends StatelessWidget {
  final ValueChanged<Activity> onOpen;
  const HomeActivitiesSection({required this.onOpen, super.key});

  @override
  Widget build(BuildContext context) => SectionShell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Eyebrow('EXPÉRIENCES À VIVRE'),
            const SizedBox(height: 14),
            const Text('Marrakech, à votre manière.', style: TextStyle(fontSize: 30, color: espresso, fontWeight: FontWeight.w300)),
            const SizedBox(height: 12),
            const Text('Des expériences choisies pour composer un séjour qui ne ressemble qu’à vous.', style: TextStyle(color: brown, fontSize: 14, height: 1.6)),
            const SizedBox(height: 25),
            FutureBuilder<List<Activity>>(
              future: ActivityRepository.instance.activities(),
              builder: (context, snapshot) {
                final items = (snapshot.data ?? <Activity>[]).take(6).toList();
                return Column(
                  children: [
                    ...items.map((item) => CatalogCard(item: item, onTap: () => onOpen(item))),
                    if (items.isNotEmpty)
                      Center(child: TextButton(onPressed: () => onOpen(items.first), child: const Text('Voir toutes les expériences  →', style: TextStyle(color: coral, fontSize: 12)))),
                  ],
                );
              },
            ),
          ],
        ),
      );
}