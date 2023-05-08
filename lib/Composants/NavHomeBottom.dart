import 'package:flutter/material.dart';

class NavHomeBottom extends StatelessWidget implements PreferredSizeWidget {
  final int selectedIndex;
  final double height;
  final Function() changeSelect;

  NavHomeBottom(this.selectedIndex,
      {this.height = kToolbarHeight, this.changeSelect = _test});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Message',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder_special_rounded),
          label: 'Documents',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_applications),
          label: 'Paramêtres',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Comptes',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blueGrey,
      unselectedItemColor: Colors.black,
      onTap: changeSelect(),
    );
  }
}

_test() {}
