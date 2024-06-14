import 'package:aman/screens/fitur/izinKeluar_screen.dart';
import 'package:aman/screens/fitur/izinPulang_screen.dart';
import 'package:aman/services/auth.dart';
import 'package:aman/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

FireStoreDatabase database = FireStoreDatabase();

class _HomePageState extends State<HomePage> {
  final AuthServices authServices = new AuthServices();
  double screenHeight = 0;
  double screenWidth = 0;
  String? currentUserName;

  Color primary = const Color.fromARGB(255, 8, 134, 143);

  void initState() {
    super.initState();
    _getCurrentUserName();
  }

  Future<void> _getCurrentUserName() async {
    try {
      String name = await database.getCurrentUserName();
      print('Fetched user name: $name');
      setState(() {
        currentUserName = name;
      });
    } catch (e) {
      print('Error fetching current user name: $e');
      setState(() {
        currentUserName = 'Nama tidak tersedia';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentUserName != null)
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(width: 55),
                    Text(
                      'Hai, $currentUserName !',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
            Text('Pilih jenis izin yang ingin kamu lakukan, ya..'),
            SizedBox(height: 60),
            InkWell(
              onTap: () {
                // Navigasi ke halaman izin keluar
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IzinKeluarPage()),
                );
              },
              child: Card(
                color: primary,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.directions_walk,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Izin Keluar',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                // Navigasi ke halaman izin keluar
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IzinPulangPage()),
                );
              },
              child: Card(
                color: primary,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Izin Pulang',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
