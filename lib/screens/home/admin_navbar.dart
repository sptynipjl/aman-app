import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class AdminNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  AdminNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: GNav(
        onTabChange: (value) => onTabChange!(value),
        mainAxisAlignment: MainAxisAlignment.center,
        activeColor: Color.fromARGB(255, 21, 179, 190),
        color: Colors.grey,
        tabActiveBorder: Border.all(color: Colors.white),
        gap: 2,
        tabs: const [
          GButton(
            icon: Icons.history,
            text: 'Rekap Absen',
          ),
          GButton(
            icon: Icons.list,
            text: 'Daftar Santri',
          ),
          GButton(
            icon: Icons.verified_user,
            text: 'Profil',
          ),
        ],
      ),
    );
  }
}
