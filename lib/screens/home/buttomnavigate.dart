// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  BottomNavBar({super.key, required this.onTabChange});
  final Color secondColor = Color.fromARGB(255, 13, 123, 131);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GNav(
        onTabChange: (value) => onTabChange!(value),
        mainAxisAlignment: MainAxisAlignment.center,
        activeColor: Colors.white,
        color: Colors.grey,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: secondColor,
        gap: 8,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Menu Utama',
          ),
          GButton(
            icon: Icons.history,
            text: 'Riwayat Absen',
          ),
          GButton(
            icon: Icons.person_outlined,
            text: 'Profil',
          ),
        ],
      ),
    );
  }
}
