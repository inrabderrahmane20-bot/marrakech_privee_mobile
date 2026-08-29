import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marrakech_privee/main.dart';

void main() {
  testWidgets('homepage shows a filter and sort toolbar above the activity list', (tester) async {
    await tester.pumpWidget(const MarrakechPriveeApp());
    await tester.pumpAndSettle();

    expect(find.text('Filtres'), findsOneWidget);
    expect(find.text('Trier par · Pertinence'), findsOneWidget);
    expect(find.text('Toutes les expériences'), findsWidgets);
    expect(find.text('Marrakech : Quad & Buggy dans le désert d’Agafay avec dîner-spectacle'), findsOneWidget);
  });

  testWidgets('event page shows the catalog and can open a detail screen', (tester) async {
    await tester.pumpWidget(const MarrakechPriveeApp());

    await tester.tap(find.text('Événements'));
    await tester.pumpAndSettle();
    expect(find.text('Événements'), findsWidgets);
    expect(find.text('Marrakech : Organisation de mariage privé clé en main'), findsOneWidget);

    await tester.tap(find.text('Marrakech : Organisation de mariage privé clé en main'));
    await tester.pumpAndSettle();
    expect(find.text('Demander cette expérience'), findsOneWidget);
  });

  testWidgets('menu opens the massive personalised request form', (tester) async {
    await tester.pumpWidget(const MarrakechPriveeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    await _openDrawerLink(tester, 'Démarrer une demande');

    expect(find.text('Dites-nous tout.'), findsOneWidget);
    expect(find.text('Nous concevons le reste.'), findsOneWidget);
    expect(find.text('Envoyer ma demande sur WhatsApp'), findsOneWidget);
  });

  testWidgets('homepage supports category filtering and sort controls', (tester) async {
    await tester.pumpWidget(const MarrakechPriveeApp());
    await tester.pumpAndSettle();

    expect(find.text('Filtres'), findsOneWidget);
    expect(find.text('Trier par · Pertinence'), findsOneWidget);

    await tester.tap(find.text('Filtres'));
    await tester.pumpAndSettle();
    expect(find.text('Toutes les catégories'), findsOneWidget);
    await tester.tap(find.text('Toutes les catégories'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Trier par · Pertinence'));
    await tester.pumpAndSettle();
    expect(find.text('Pertinence'), findsWidgets);
  });

  testWidgets('drawer opens and navigates to about page', (tester) async {
    await tester.pumpWidget(const MarrakechPriveeApp());

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.text('Démarrer une demande'), findsOneWidget);
    expect(find.text('Guide de voyage'), findsOneWidget);

    await _openDrawerLink(tester, 'À propos');
    expect(find.text('L’art de prendre soin.'), findsOneWidget);
  });
}

Future<void> _openDrawerLink(WidgetTester tester, String label) async {
  final drawerScrollable = find.descendant(of: find.byType(Drawer), matching: find.byType(Scrollable));
  await tester.scrollUntilVisible(find.text(label), 120, scrollable: drawerScrollable);
  await tester.pumpAndSettle();
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}