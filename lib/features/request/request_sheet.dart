import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/common.dart';

void openRequestSheet(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: cream,
      builder: (_) => const RequestSheet(),
    );

class RequestSheet extends StatelessWidget {
  const RequestSheet({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(23, 25, 23, MediaQuery.viewInsetsOf(context).bottom + 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Votre demande', style: TextStyle(fontSize: 30, color: espresso, fontWeight: FontWeight.w300)),
            const SizedBox(height: 8),
            const Text('Parlez-nous de votre projet.', style: TextStyle(color: brown)),
            const SizedBox(height: 20),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(filled: true, fillColor: blush, hintText: 'Un séjour, un événement, une envie...', border: InputBorder.none),
            ),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: PillButton(label: 'Envoyer ma demande', onPressed: () => Navigator.pop(context))),
          ],
        ),
      );
}