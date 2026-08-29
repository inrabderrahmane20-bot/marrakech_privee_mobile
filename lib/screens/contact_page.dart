import 'package:flutter/material.dart';

import '../config.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) => const PageFrame(
        title: 'Contact',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Eyebrow('UNE CONVERSATION COMMENCE ICI'),
            SizedBox(height: 15),
            Text('Parlons de ce qui vous ferait plaisir.', style: TextStyle(fontSize: 31, color: espresso, fontWeight: FontWeight.w300)),
            SizedBox(height: 18),
            Text('Un projet, une question ou simplement une envie de Marrakech ? Notre équipe vous répond avec attention.', style: TextStyle(color: brown, fontSize: 15, height: 1.65)),
            SizedBox(height: 28),
            Text(contactEmail, style: TextStyle(color: coral, fontSize: 15)),
            SizedBox(height: 12),
            Text(whatsappNumber, style: TextStyle(color: brown, fontSize: 15)),
          ],
        ),
      );
}