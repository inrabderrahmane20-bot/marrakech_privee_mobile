// Dev-only visual preview generator.
//
// Run:
//   flutter test tool/previews_test.dart --update-goldens
//
// Writes phone-sized PNG screenshots into tool/goldens/ that can be opened
// to review the main screens without launching an emulator. Loads a real
// (Roboto) font from the Flutter SDK cache so text renders as glyps instead
// of test blocks.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marrakech_privee/data/activities.dart' as seed;
import 'package:marrakech_privee/data/user_lists.dart';
import 'package:marrakech_privee/screens/about_page.dart';
import 'package:marrakech_privee/screens/events_page.dart';
import 'package:marrakech_privee/screens/favorites_page.dart';
import 'package:marrakech_privee/screens/request_page.dart';
import 'package:marrakech_privee/theme/app_theme.dart';

final String _fontRoot =
    '${Platform.environment['FLUTTER_ROOT'] ?? 'C:/Users/inrab/Documents/flutter'}/bin/cache/artifacts/material_fonts';

Future<void> _registerFont(String family, String file) async {
  final bytes = File('$_fontRoot/$file').readAsBytesSync();
  final loader = FontLoader(family)..addFont(Future.value(ByteData.sublistView(bytes)));
  await loader.load();
}

void _phoneView(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.reset);
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 150));
  await tester.pump(const Duration(milliseconds: 150));
  await tester.pump(const Duration(milliseconds: 150));
}

void main() {
  setUpAll(() async {
    await _registerFont('serif', 'roboto-regular.ttf');
    await _registerFont('Roboto', 'roboto-regular.ttf');
  });

  testWidgets('preview about', (tester) async {
    _phoneView(tester);
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const AboutPage()));
    await _settle(tester);
    await expectLater(find.byType(AboutPage), matchesGoldenFile('goldens/about.png'));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('preview bucket', (tester) async {
    _phoneView(tester);
    UserLists.instance.toggleBucket(seed.activities.first);
    UserLists.instance.toggleBucket(seed.activities[1]);
    addTearDown(() {
      UserLists.instance.toggleBucket(seed.activities.first);
      UserLists.instance.toggleBucket(seed.activities[1]);
    });
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const BucketPage()));
    await _settle(tester);
    await expectLater(find.byType(BucketPage), matchesGoldenFile('goldens/bucket.png'));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('preview request', (tester) async {
    _phoneView(tester);
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: RequestPage(activity: seed.activities.first)),
    );
    await _settle(tester);
    await expectLater(find.byType(RequestPage), matchesGoldenFile('goldens/request.png'));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('preview events', (tester) async {
    _phoneView(tester);
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: EventsPage(onOpenActivity: (_) {})),
    );
    await _settle(tester);
    await expectLater(find.byType(EventsPage), matchesGoldenFile('goldens/events.png'));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}