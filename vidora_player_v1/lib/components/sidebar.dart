import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int activeIndex;
  final Function(int) onItemTap;

  const Sidebar({
    super.key,
    required this.activeIndex,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: MediaQuery.of(context).size.height - 30,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.07, 0.24, 0.58, 0.83],
          colors: [
            Color(0xFF213232),
            Color(0xFF273E3E),
            Color(0xFF273E3E),
            Color(0xFF202F2F),
          ],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 0)),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          SidebarItem(
            icon: Icons.home_outlined,
            label: "Home",
            selected: activeIndex == 0,
            onTap: () => onItemTap(0),
          ),
          SidebarItem(
            icon: Icons.explore_outlined,
            label: "Browse",
            selected: activeIndex == 1,
            onTap: () => onItemTap(1),
          ),
          SidebarItem(
            icon: Icons.queue_music_outlined,
            label: "Playlist",
            selected: activeIndex == 2,
            onTap: () => onItemTap(2),
          ),
          SidebarItem(
            icon: Icons.library_books_outlined,
            label: "Library",
            selected: activeIndex == 3,
            onTap: () => onItemTap(3),
          ),
          SidebarItem(
            icon: Icons.favorite_border,
            label: "Favorite",
            selected: activeIndex == 4,
            onTap: () => onItemTap(4),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedBg = const Color(0xFF2A4B4B).withOpacity(0.55);
    final Color selectedColor = Colors.white;
    final Color unselectedColor = const Color(0xFF8CAAB3);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: selected ? selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? selectedColor : unselectedColor,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color: selected ? selectedColor : unselectedColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}