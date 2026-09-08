import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marrakech_privee/data/activities.dart' as seed;
import 'package:marrakech_privee/data/user_lists.dart';
import 'package:marrakech_privee/main.dart';
import 'package:marrakech_privee/screens/favorites_page.dart';

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

  testWidgets('event page offers the same filter, sort and layout as activities', (tester) async {
    await tester.pumpWidget(const MarrakechPriveeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Événements'));
    await tester.pumpAndSettle();
    expect(find.text('Filtres'), findsOneWidget);
    expect(find.text('Trier par · Pertinence'), findsOneWidget);
    expect(find.textContaining('expériences'), findsWidgets);
  });

  testWidgets('search shows the whole catalogue before typing', (tester) async {
    await tester.pumpWidget(const MarrakechPriveeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Rechercher'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Toutes les expériences ·'), findsOneWidget);
    expect(find.text('Marrakech : Quad & Buggy dans le désert d’Agafay avec dîner-spectacle'), findsOneWidget);

    // Experiences (events) are also part of the initial list.
    await tester.scrollUntilVisible(
      find.text('Marrakech : Organisation de mariage privé clé en main'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
  });

  testWidgets('bucket list page lets the user confirm the selection with a request', (tester) async {
    UserLists.instance.toggleBucket(seed.activities.first);
    addTearDown(() => UserLists.instance.toggleBucket(seed.activities.first));

    await tester.pumpWidget(const MaterialApp(home: BucketPage()));
    await tester.pumpAndSettle();

    expect(find.text('Confirmer ma bucket list'), findsOneWidget);

    await tester.tap(find.text('Confirmer ma bucket list'));
    await tester.pumpAndSettle();

    expect(find.text('Envoyer sur WhatsApp'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Instagram'), findsOneWidget);
    expect(find.textContaining('Quad & Buggy'), findsWidgets);
  });

  testWidgets('menu opens the massive personalised request form', (tester) async {
    await tester.pumpWidget(const MarrakechPriveeApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    await _openDrawerLink(tester, 'Démarrer une demande');

    expect(find.text('Dites-nous tout.'), findsOneWidget);
    expect(find.text('Nous concevons le reste.'), findsOneWidget);
    expect(find.text('Envoyer sur WhatsApp'), findsOneWidget);
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