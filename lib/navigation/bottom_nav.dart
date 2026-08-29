import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BottomNavList extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onSearch;
  final VoidCallback onMenu;

  const BottomNavList({required this.selectedIndex, required this.onSelected, required this.onSearch, required this.onMenu, super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: cream,
          border: Border(top: BorderSide(color: Color(0x226B5248))),
        ),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: BottomNavItem(icon: Icons.home_outlined, label: 'Accueil', active: selectedIndex == 0, onTap: () => onSelected(0))),
              Expanded(child: BottomNavItem(icon: Icons.event_outlined, label: 'Événements', active: selectedIndex == 1, onTap: () => onSelected(1))),
              Expanded(child: BottomNavItem(icon: Icons.search, label: 'Rechercher', onTap: onSearch)),
              Expanded(child: BottomNavItem(icon: Icons.menu, label: 'Menu', onTap: onMenu)),
            ],
          ),
        ),
      );
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const BottomNavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          constraints: const BoxConstraints(minHeight: 54),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          decoration: BoxDecoration(color: active ? blush : Colors.transparent, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 21, color: active ? coral : brown),
              const SizedBox(height: 3),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: active ? coral : brown, fontSize: 9, fontWeight: active ? FontWeight.w600 : FontWeight.w400)),
            ],
          ),
        ),
      );
}