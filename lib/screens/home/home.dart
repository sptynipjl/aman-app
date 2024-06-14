import 'package:aman/screens/fitur/history.dart';

import 'package:aman/screens/fitur/profil.dart';
import 'package:aman/screens/home/buttomnavigate.dart';
import 'package:aman/screens/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> daftarAbsen = [];
  bool isAbsenKeluar = false;
  bool isAbsenMasuk = false;
  late DateTime now;
  int currentIndex = 0;

  final Color primaryColor = const Color.fromARGB(255, 21, 179, 190);
  final Color secondColor = Color.fromARGB(255, 9, 82, 87);

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
  }
  // final AuthServices authServices = new AuthServices();
  // double screenHeight = 0;
  // double screenWidth = 0;

  int _currentindex = 0;
  void navigateBottomBar(int newIndex) {
    setState(() {
      _currentindex = newIndex;
    });
  }

  // List<IconData> navigationIcons = [
  //   Icons.history,
  //   Icons.home_max_rounded,
  //   Icons.verified_user_rounded,
  // ]

  final List<Widget> _pages = [
    //Menu Utama
    const HomePage(),

    //Rekap Absen
    const HistoryPage(),

    //Profil
    const Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    // screenHeight = MediaQuery.of(context).size.height;
    // screenWidth = MediaQuery.of(context).size.width;
    // final signOut = Material(
    //   child: MaterialButton(
    //     onPressed: () async {
    //       await authServices.signOut();
    //     },
    //     child: Text("Logout"),
    //   ),
    // );

    return Scaffold(
      // backgroundColor: secondColor,
      bottomNavigationBar: BottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: _pages[_currentindex],
    );
  }
}

/*
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman izin keluar
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IzinKeluarPage()),
                );
              },
              child: Text('Izin Keluar'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman izin pulang
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IzinPulangPage()),
                );
              },
              child: Text('Izin Pulang'),
            ),
          ],
        ),
      ),
    );
  }
}

class IzinKeluarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Izin Keluar'),
      ),
      body: Center(
        child: Text('Halaman Izin Keluar'),
      ),
    );
  }
}

class IzinPulangPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Izin Pulang'),
      ),
      body: Center(
        child: Text('Halaman Izin Pulang'),
      ),
    );
  }
}
*/