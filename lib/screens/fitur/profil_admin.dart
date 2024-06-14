import 'package:aman/screens/authenticate/login.dart';
import 'package:aman/screens/fitur/tambahUser.dart';
import 'package:aman/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilAdmin extends StatefulWidget {
  const ProfilAdmin({super.key});

  @override
  State<ProfilAdmin> createState() => _ProfilAdminState();
}

class _ProfilAdminState extends State<ProfilAdmin> {
  final AuthServices authServices = AuthServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Color primary = const Color.fromARGB(255, 21, 179, 190);
  double screenHeight = 0;
  double screenWidth = 0;

  // User data
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('User').doc(user.email).get();
        setState(() {
          userData = doc.data() as Map<String, dynamic>?;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    final signOutButton = ElevatedButton(
      onPressed: () async {
        bool? confirmLogout = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 210, 252, 255),
              title: Text('Konfirmasi Logout'),
              content: Text(
                'Apakah kamu yakin ingin keluar?',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    'Tidak',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    'Ya',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          },
        );

        if (confirmLogout == true) {
          await authServices.signOut();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text("Keluar"),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Profil Admin"),
        backgroundColor: primary,
        automaticallyImplyLeading: false,
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Icon(
                      Icons.person,
                      color: Color.fromARGB(31, 7, 137, 160),
                      size: screenWidth / 2,
                    ),
                  ),
                  Text("${userData!['nama']}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text("${userData!['angkatan']}",
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 100),
                  Material(
                    shape: StadiumBorder(),
                    color: Color.fromARGB(255, 19, 165, 175),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TambahUser()),
                        );
                      },
                      child: Text(
                        "Tambahkan Santri Baru",
                        selectionColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                  Center(child: signOutButton),
                ],
              ),
            ),
    );
  }
}
