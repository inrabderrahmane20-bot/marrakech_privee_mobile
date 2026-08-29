import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../screens/detail/activity_detail_page.dart';
import '../screens/events_page.dart';
import '../screens/home/home_page.dart';
import '../search/experience_search_delegate.dart';
import 'app_drawer.dart';
import 'bottom_nav.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selectedIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  void selectPage(int index) {
    Navigator.of(context).maybePop();
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomePage(),
      EventsPage(onOpenActivity: _openActivity),
    ];

    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(onSelect: selectPage),
      body: IndexedStack(index: selectedIndex, children: pages),
      bottomNavigationBar: BottomNavList(
        selectedIndex: selectedIndex,
        onSelected: selectPage,
        onSearch: () => showSearch(context: context, delegate: ExperienceSearchDelegate()),
        onMenu: () => scaffoldKey.currentState?.openDrawer(),
      ),
    );
  }

  void _openActivity(Activity activity) => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ActivityDetailPage(activity: activity)));
}