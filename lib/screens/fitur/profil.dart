import 'package:aman/screens/authenticate/login.dart';
import 'package:aman/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  final AuthServices authServices = AuthServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Color primaryColor = const Color.fromARGB(255, 21, 179, 190);
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
    TextStyle labelStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    TextStyle valueStyle = TextStyle(fontSize: 18);
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
        backgroundColor: primaryColor, // foreground
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text("Keluar"),
    );
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profil"),
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
        ),
        body: userData == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 50),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: primaryColor,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child:
                                              Text("Nama", style: labelStyle),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            ": ${userData!['nama']}",
                                            style: valueStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text("NIS", style: labelStyle),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(": ${userData!['nis']}",
                                              style: valueStyle),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child:
                                              Text("Kamar", style: labelStyle),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(": ${userData!['kamar']}",
                                              style: valueStyle),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text("Angkatan",
                                              style: labelStyle),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                              ": ${userData!['angkatan']}",
                                              style: valueStyle),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child:
                                              Text("Alamat", style: labelStyle),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                              ": ${userData!['alamat']}",
                                              style: valueStyle),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            signOutButton,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
