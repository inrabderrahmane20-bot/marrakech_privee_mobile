import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marrakech_privee/main.dart';

Future<void> pumpApp(WidgetTester tester, Size size, double textScale) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(const MarrakechPriveeApp());
  await tester.pumpAndSettle();
}

Future<void> tapDrawerLink(WidgetTester tester, String label) async {
  await tester.tap(find.text('Menu'));
  await tester.pumpAndSettle();
  final drawerScrollable = find.descendant(of: find.byType(Drawer), matching: find.byType(Scrollable));
  await tester.scrollUntilVisible(find.text(label), 120, scrollable: drawerScrollable);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('probe: no overflow on small phone across key pages', (tester) async {
    await pumpApp(tester, const Size(320, 568), 1.0);

    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Marrakech : Quad & Buggy dans le désert d’Agafay avec dîner-spectacle'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'detail page overflow');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tapDrawerLink(tester, 'Ma bucket list');
    expect(tester.takeException(), isNull, reason: 'bucket page overflow');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tapDrawerLink(tester, 'Mes favoris');
    expect(tester.takeException(), isNull, reason: 'favorites page overflow');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tapDrawerLink(tester, 'Démarrer une demande');
    expect(tester.takeException(), isNull, reason: 'request page overflow');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Événements'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'events page overflow');
  });

  testWidgets('probe: no overflow with large text scale on home', (tester) async {
    await pumpApp(tester, const Size(390, 844), 1.4);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Filtres'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'filter sheet overflow');
    await tester.tap(find.text('Toutes les catégories'));
    await tester.pumpAndSettle();

    await tapDrawerLink(tester, 'Démarrer une demande');
    expect(tester.takeException(), isNull, reason: 'request page overflow (large text)');
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Événements'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'events page overflow (large text)');
  });
}