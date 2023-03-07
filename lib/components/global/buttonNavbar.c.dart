import 'package:flutter/material.dart';

class ButtonNav extends StatelessWidget {
  final int currentPage;
  final Function(int) setCurrent;
  const ButtonNav(
      {super.key, required this.currentPage, required this.setCurrent});
  static const Color selectedColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.grey[200],
      elevation: 0,
      selectedIndex: currentPage,
      destinations: const [
        // NavigationDestination(
        //   selectedIcon: Icon(Icons.home, color: selectedColor),
        //   icon: Icon(Icons.home),
        //   label: 'Home',
        //   tooltip: 'Home',
        // ),
        NavigationDestination(
          icon: Icon(Icons.bookmark_add),
          selectedIcon: Icon(Icons.bookmark_add, color: selectedColor),
          label: 'Todos',
          tooltip: 'Todos',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          selectedIcon: Icon(Icons.person, color: selectedColor),
          label: 'Profile',
          tooltip: 'Profile',
        ),
      ],
      onDestinationSelected: (int index) {
        if (index == currentPage) {
          return;
        }
        setCurrent(index);
      },
    );
  }
}
