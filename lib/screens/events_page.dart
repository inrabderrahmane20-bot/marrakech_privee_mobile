import 'package:flutter/material.dart';

import '../models/activity.dart';
import 'catalog_page.dart';

class EventsPage extends StatelessWidget {
  final ValueChanged<Activity> onOpenActivity;
  const EventsPage({required this.onOpenActivity, super.key});

  @override
  Widget build(BuildContext context) {
    return CatalogPage(
      title: 'Événements',
      intro: 'Des célébrations privées et professionnelles imaginées autour de vous.',
      section: 'events',
      onOpen: onOpenActivity,
    );
  }
}