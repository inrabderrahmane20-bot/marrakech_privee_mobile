import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/common.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) => const PageFrame(
        title: 'Guide de voyage',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageTile('marrakech_medina_alley_warm_light.webp', 270),
            SizedBox(height: 25),
            Text('Marrakech,\nà ressentir.', style: TextStyle(fontSize: 34, color: espresso, height: 1.05, fontWeight: FontWeight.w300)),
            SizedBox(height: 15),
            Text('Nos adresses, nos itinéraires et les détails qui rendent un séjour au Maroc inoubliable.', style: TextStyle(color: brown, fontSize: 15, height: 1.65)),
          ],
        ),
      );
}