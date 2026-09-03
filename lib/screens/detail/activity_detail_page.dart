import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../config.dart';
import '../../data/activity_repository.dart';
import '../../data/user_lists.dart';
import '../../models/activity.dart';
import '../../screens/request_page.dart';
import '../../theme/app_theme.dart';
import '../../widgets/activity_image.dart';
import '../../widgets/common.dart';
import '../../widgets/favorite_button.dart';

class ActivityDetailPage extends StatefulWidget {
  final Activity activity;
  const ActivityDetailPage({required this.activity, super.key});

  @override
  State<ActivityDetailPage> createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  late Activity _activity = widget.activity;

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  Future<void> _loadGallery() async {
    final updated = await ActivityRepository.instance.loadGallery(_activity);
    if (mounted && updated.hasGallery && updated.images != _activity.images) {
      setState(() => _activity = updated);
    }
  }

  Future<void> _openLink(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lien copié — collez-le dans votre navigateur ou Cartes.')),
      );
    }
  }

  void _shareOnWhatsApp() {
    final text = 'Découvrons cette expérience Marrakech Privée : ${_activity.title}\n\n$whatsappLink';
    Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message copié — collez-le dans WhatsApp au $whatsappNumber.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = _activity;
    return PageFrame(
      title: activity.categoryLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(14), child: _GalleryCarousel(activity: activity)),
              Positioned(top: 10, right: 10, child: FavoriteButton(activity: activity, iconSize: 19)),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(30), border: Border.all(color: blushDeep)),
                child: Text(activity.categoryLabel, style: const TextStyle(color: coral, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
              if (activity.city.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on, size: 13, color: brown),
                    const SizedBox(width: 3),
                    Text(activity.city, style: const TextStyle(color: brown, fontSize: 12)),
                  ],
                ),
              if (activity.isVipOnly)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                  decoration: BoxDecoration(color: espresso, borderRadius: BorderRadius.circular(30)),
                  child: const Text('VIP', style: TextStyle(color: cream, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(activity.title, style: const TextStyle(color: espresso, fontSize: 31, height: 1.05, fontWeight: FontWeight.w300)),
          const SizedBox(height: 15),
          Text(activity.description, style: const TextStyle(color: brown, fontSize: 15, height: 1.65)),
          if (activity.address?.isNotEmpty == true || activity.mapLink?.isNotEmpty == true) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(14), border: Border.all(color: blushDeep)),
              child: Row(
                children: [
                  const Icon(Icons.map_outlined, size: 18, color: coral),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(activity.address ?? (activity.city.isEmpty ? 'Marrakech' : activity.city), style: const TextStyle(color: espresso, fontSize: 13, height: 1.4)),
                  ),
                  if (activity.mapLink?.isNotEmpty == true)
                    TextButton(
                      onPressed: () => _openLink(activity.mapLink!),
                      style: TextButton.styleFrom(foregroundColor: coral, padding: const EdgeInsets.symmetric(horizontal: 8)),
                      child: const Text('Carte', style: TextStyle(fontSize: 12, decoration: TextDecoration.underline)),
                    ),
                ],
              ),
            ),
          ],
          if (_hasFacts(activity)) ...[
            const SizedBox(height: 22),
            _FactsCard(activity: activity),
          ],
          if (activity.durationOptions.isNotEmpty) ...[
            const SizedBox(height: 22),
            const _SectionTitle('Options de durée'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: activity.durationOptions.map((option) => _InfoChip(label: option, icon: Icons.schedule)).toList(),
            ),
          ],
          if (activity.guestOptions.isNotEmpty) ...[
            const SizedBox(height: 22),
            const _SectionTitle('Options de groupes'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: activity.guestOptions.map((option) => _InfoChip(label: option, icon: Icons.people_outline)).toList(),
            ),
          ],
          const SizedBox(height: 26),
          ListenableBuilder(
            listenable: UserLists.instance,
            builder: (context, _) {
              final inBucket = UserLists.instance.isBucket(activity);
              return SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => UserLists.instance.toggleBucket(activity),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: espresso,
                    side: const BorderSide(color: blushDeep),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const StadiumBorder(),
                  ),
                  icon: Icon(inBucket ? Icons.check_circle : Icons.bookmark_add_outlined, size: 18, color: coral),
                  label: Text(inBucket ? 'Dans ma bucket list' : 'Ajouter à ma bucket list', style: const TextStyle(fontSize: 12)),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: PillButton(label: 'Demander cette expérience', onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const RequestPage()))),
          ),
          const SizedBox(height: 6),
          Center(
            child: TextButton(
              onPressed: _shareOnWhatsApp,
              style: TextButton.styleFrom(foregroundColor: brown),
              child: const Text('Partager sur WhatsApp', style: TextStyle(fontSize: 12, decoration: TextDecoration.underline)),
            ),
          ),
        ],
      ),
    );
  }

  static bool _hasFacts(Activity a) =>
      a.durationLabel.isNotEmpty ||
      (a.maxGuests != null && a.maxGuests! > 0) ||
      a.priceLabel.isNotEmpty ||
      a.bookingMode != null ||
      a.pricingModel != null;
}

class _FactsCard extends StatelessWidget {
  final Activity activity;
  const _FactsCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    void add(IconData icon, String label, String value) {
      rows.add(_FactRow(icon: icon, label: label, value: value));
    }

    final duration = activity.durationLabel;
    if (duration.isNotEmpty) add(Icons.schedule, 'Durée', duration);
    final guests = activity.maxGuests;
    if (guests != null && guests > 0) add(Icons.people_outline, 'Capacité', 'Jusqu’à $guests personnes');
    add(Icons.payments_outlined, 'Tarif', activity.priceLabel);
    final booking = activity.bookingMode;
    if (booking != null) {
      final label = booking == 'QUOTE_REQUEST'
          ? 'Devis personnalisé'
          : booking == 'RESERVATION_REQUEST'
              ? 'Sur réservation'
              : booking.split('_').map((w) => w.toLowerCase().capitalized).join(' ');
      add(Icons.event_note_outlined, 'Réservation', label);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(16), border: Border.all(color: blushDeep)),
      child: Column(children: rows),
    );
  }
}

class _FactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _FactRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Icon(icon, size: 17, color: coral),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(color: brown, fontSize: 13)),
            const Spacer(),
            Flexible(child: Text(value, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end, style: const TextStyle(color: espresso, fontSize: 13, fontWeight: FontWeight.w600))),
          ],
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(color: espresso, fontSize: 16, fontWeight: FontWeight.w600));
}

class _InfoChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _InfoChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: cream, borderRadius: BorderRadius.circular(30), border: Border.all(color: blushDeep)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: coral),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: espresso, fontSize: 12)),
          ],
        ),
      );
}

class _GalleryCarousel extends StatefulWidget {
  final Activity activity;
  const _GalleryCarousel({required this.activity});

  @override
  State<_GalleryCarousel> createState() => _GalleryCarouselState();
}

class _GalleryCarouselState extends State<_GalleryCarousel> {
  final PageController _controller = PageController();
  late List<String> _images = widget.activity.images;
  int _current = 0;

  @override
  void didUpdateWidget(covariant _GalleryCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.images != widget.activity.images) {
      _images = widget.activity.images;
      _current = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = _images;
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          Positioned.fill(
            child: images.isEmpty
                ? ActivityImage(activity: widget.activity, width: double.infinity, height: 280)
                : PageView.builder(
                    controller: _controller,
                    itemCount: images.length,
                    onPageChanged: (i) => setState(() => _current = i),
                    itemBuilder: (_, i) => _image(images[i]),
                  ),
          ),
          if (images.length > 1)
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: IgnorePointer(
                child: Center(child: _Dots(count: images.length, current: _current)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _image(String dataUri) {
    final memory = DataUriImageCache.memoryImage(dataUri);
    if (memory != null) {
      return Image(
        image: memory,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 280,
        errorBuilder: (_, _, _) => const _GalleryFallback(),
      );
    }
    return const _GalleryFallback();
  }
}

/// The thin dotted progress indicator the user asked for: one dot per image,
/// the active dot stretches wider in coral while the others stay small and
/// light — it updates as the user slides left/right.
class _Dots extends StatelessWidget {
  final int count;
  final int current;
  const _Dots({required this.count, required this.current});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(count, (i) {
            final active = i == current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? coral : Colors.white70,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      );
}

class _GalleryFallback extends StatelessWidget {
  const _GalleryFallback();

  @override
  Widget build(BuildContext context) => Container(
        color: const Color(0xFFE8E0D6),
        child: const Icon(Icons.image_not_supported_outlined, color: Color(0xFF9B6B4A)),
      );
}

extension on String {
  String get capitalized => isEmpty ? this : this[0].toUpperCase() + substring(1);
}