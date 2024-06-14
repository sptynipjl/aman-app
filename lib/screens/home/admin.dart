import 'package:aman/screens/fitur/daftarSantri.dart';
import 'package:aman/screens/fitur/profil_admin.dart';
import 'package:aman/screens/home/admin_homepage.dart';
import 'package:aman/screens/home/admin_navbar.dart';
import 'package:flutter/material.dart';

class AdminMenu extends StatefulWidget {
  const AdminMenu({super.key});

  @override
  State<AdminMenu> createState() => _AdminMenuState();
}

class _AdminMenuState extends State<AdminMenu> {
  int _currentindex = 0;
  void navigateBottomBar(int newIndex) {
    setState(() {
      _currentindex = newIndex;
    });
  }

  final List<Widget> _pages = [
    //Rekap Absen
    const AdminHomePage(),

    DaftarSantri(),

    //Profil
    const ProfilAdmin(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AdminNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: _pages[_currentindex],
    );
  }
}
