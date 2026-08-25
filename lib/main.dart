import 'package:flutter/material.dart';

const ink = Color(0xFF28231F);
const ivory = Color(0xFFF4F0E9);
const sand = Color(0xFFE8E0D6);
const terracotta = Color(0xFF9B6B4A);

void main() => runApp(const MarrakechPriveeApp());

class MarrakechPriveeApp extends StatelessWidget {
  const MarrakechPriveeApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Marrakech Privee',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: ivory,
          colorScheme: ColorScheme.fromSeed(seedColor: terracotta),
          fontFamily: 'Georgia',
          useMaterial3: true,
        ),
        home: const AppShell(),
      );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selected = 0;

  void openConcierge() => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: ivory,
        builder: (_) => const ConciergeSheet(),
      );

  @override
  Widget build(BuildContext context) {
    const pages = [HomePage(), AboutPage()];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: selected, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (index) => setState(() => selected = index),
        backgroundColor: ivory,
        indicatorColor: sand,
        height: 72,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'About'),
        ],
      ),
      floatingActionButton: selected == 0
          ? FloatingActionButton.extended(
              onPressed: openConcierge,
              backgroundColor: ink,
              foregroundColor: ivory,
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: const Text('Make it happen'),
            )
          : null,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 110),
        children: [
          const BrandMark(),
          const SizedBox(height: 38),
          const Text('Good evening,', style: TextStyle(fontSize: 16, color: Color(0xFF786F67))),
          const Text('Abdou.', style: TextStyle(fontSize: 42, height: 1.05, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          const Sans('What can we arrange for you?'),
          const SizedBox(height: 26),
          const HeroExperience(),
          const SizedBox(height: 34),
          const SectionHeading('Curated for you'),
          const SizedBox(height: 16),
          const CategoryRail(),
          const SizedBox(height: 34),
          const ConciergeCard(),
          const SizedBox(height: 40),
          const SectionHeading('The Privee selection'),
          const SizedBox(height: 16),
          const ExperienceTile(
            image: 'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e?w=900',
            title: 'Dinner under the stars',
            subtitle: 'Agafay desert · Private experience',
          ),
        ],
      );
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 48),
        children: [
          const BrandMark(),
          const SizedBox(height: 42),
          ClipRRect(borderRadius: BorderRadius.circular(2), child: Image.network('https://images.unsplash.com/photo-1548013146-72479768bada?w=1200', height: 270, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: sand))),
          const SizedBox(height: 34),
          const Text('The art of\nbeing looked after.', style: TextStyle(fontSize: 38, height: 1.02, fontWeight: FontWeight.w500)),
          const SizedBox(height: 20),
          const Sans('Marrakech Privee is your discreet, deeply local connection to the city. From a hidden courtyard to a celebration that feels entirely your own, we arrange the details that turn a stay into a story.', height: 1.6, size: 16),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFFD2C7B9)),
          const SizedBox(height: 22),
          const Sans('OUR PROMISE', color: terracotta, size: 12, weight: FontWeight.bold, spacing: 1.6),
          const SizedBox(height: 12),
          const Text('Tell us what you have in mind.\nWe take care of the rest.', style: TextStyle(fontSize: 28, height: 1.2, fontWeight: FontWeight.w500)),
        ],
      );
}

class Sans extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final double height;
  final FontWeight weight;
  final double spacing;
  final TextAlign? align;
  const Sans(this.text, {super.key, this.color = const Color(0xFF786F67), this.size = 15, this.height = 1.45, this.weight = FontWeight.normal, this.spacing = 0, this.align});
  @override
  Widget build(BuildContext context) => Text(text, textAlign: align, style: TextStyle(fontFamily: 'Arial', color: color, fontSize: size, height: height, fontWeight: weight, letterSpacing: spacing));
}

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});
  @override
  Widget build(BuildContext context) => const Row(children: [Sans('MARRAKECH', color: ink, size: 12, weight: FontWeight.bold, spacing: 3.2), Spacer(), Text('PRIVEE', style: TextStyle(fontSize: 17, letterSpacing: 1.8, fontWeight: FontWeight.w500))]);
}

class HeroExperience extends StatelessWidget {
  const HeroExperience({super.key});
  @override
  Widget build(BuildContext context) => ClipRRect(borderRadius: BorderRadius.circular(2), child: Stack(alignment: Alignment.bottomLeft, children: [Image.network('https://images.unsplash.com/photo-1500534623283-312aade485b7?w=1200', height: 390, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 390, color: const Color(0xFF6D594A))), Container(height: 390, padding: const EdgeInsets.all(24), decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xCC201B17)])), child: const Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [Sans('YOUR PRIVATE', color: Color(0xFFE7C9A8), size: 11, spacing: 2), SizedBox(height: 8), Text('Marrakech.', style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w500)), SizedBox(height: 6), Sans('Exceptional experiences, curated around you.', color: Colors.white70, size: 14)]))]));
}

class CategoryRail extends StatelessWidget {
  const CategoryRail({super.key});
  @override
  Widget build(BuildContext context) => SizedBox(height: 76, child: ListView(scrollDirection: Axis.horizontal, children: const [CategoryItem(Icons.restaurant_outlined, 'Dining'), CategoryItem(Icons.spa_outlined, 'Wellness'), CategoryItem(Icons.wb_sunny_outlined, 'Desert'), CategoryItem(Icons.celebration_outlined, 'Events'), CategoryItem(Icons.home_work_outlined, 'Villas')]));
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const CategoryItem(this.icon, this.label, {super.key});
  @override
  Widget build(BuildContext context) => Container(width: 84, margin: const EdgeInsets.only(right: 10), decoration: BoxDecoration(color: sand, borderRadius: BorderRadius.circular(2)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: terracotta, size: 24), const SizedBox(height: 8), Sans(label, color: const Color(0xFF4D443C), size: 11)]));
}

class SectionHeading extends StatelessWidget {
  final String label;
  const SectionHeading(this.label, {super.key});
  @override
  Widget build(BuildContext context) => Row(children: [Text(label, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w500)), const Spacer(), const Sans('VIEW ALL', color: terracotta, size: 11, weight: FontWeight.bold, spacing: 1.2)]);
}

class ConciergeCard extends StatelessWidget {
  const ConciergeCard({super.key});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: ink, borderRadius: BorderRadius.circular(2)), child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.auto_awesome, color: Color(0xFFE7C9A8), size: 22), SizedBox(height: 20), Text('Need something special?', style: TextStyle(color: Colors.white, fontSize: 23)), SizedBox(height: 8), Sans('Tell your concierge what you have in mind. We will take care of the rest.', color: Colors.white70, size: 14), SizedBox(height: 22), Sans('ASK MY CONCIERGE  →', color: Color(0xFFE7C9A8), size: 11, weight: FontWeight.bold, spacing: 1.3)]));
}

class ExperienceTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  const ExperienceTile({super.key, required this.image, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [ClipRRect(borderRadius: BorderRadius.circular(2), child: Image.network(image, height: 104, width: 128, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 104, width: 128, color: sand))), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const SizedBox(height: 4), Sans('ON REQUEST', color: terracotta, size: 10, weight: FontWeight.bold, spacing: 1.1), const SizedBox(height: 8), Text(title, style: const TextStyle(fontSize: 20, height: 1.1, fontWeight: FontWeight.w500)), const SizedBox(height: 8), Sans(subtitle, size: 12)]))]);
}

class ConciergeSheet extends StatelessWidget {
  const ConciergeSheet({super.key});
  @override
  Widget build(BuildContext context) => Padding(padding: EdgeInsets.only(left: 24, right: 24, top: 28, bottom: MediaQuery.viewInsetsOf(context).bottom + 28), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Center(child: Container(width: 38, height: 4, color: const Color(0xFFD2C7B9))), const SizedBox(height: 30), const Text('Make it happen.', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500)), const SizedBox(height: 8), const Sans('What would you like us to arrange?'), const SizedBox(height: 24), const TextField(maxLines: 4, decoration: InputDecoration(hintText: 'A romantic dinner, a private villa, a celebration...', filled: true, fillColor: Colors.white54, border: OutlineInputBorder(borderRadius: BorderRadius.zero, borderSide: BorderSide.none), contentPadding: EdgeInsets.all(16))), const SizedBox(height: 18), SizedBox(width: double.infinity, child: FilledButton(onPressed: () => Navigator.pop(context), style: ButtonStyle(backgroundColor: const WidgetStatePropertyAll(ink), padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 18)), shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.zero))), child: const Sans('LET YOUR CONCIERGE TAKE IT FROM HERE', color: ivory, size: 11, weight: FontWeight.bold, spacing: 1.1))) ]));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
