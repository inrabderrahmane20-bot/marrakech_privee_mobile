import 'package:flutter/material.dart';

import 'navigation/app_shell.dart';
import 'theme/app_theme.dart';

class MarrakechPriveeApp extends StatelessWidget {
  const MarrakechPriveeApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Marrakech Privee',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const AppShell(),
      );
}