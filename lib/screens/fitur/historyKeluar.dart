import 'package:aman/screens/fitur/historyKeluar_Tile.dart';
import 'package:aman/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryKeluar extends StatefulWidget {
  final List<String> absenList;

  const HistoryKeluar(this.absenList, {Key? key}) : super(key: key);

  @override
  State<HistoryKeluar> createState() => _HistoryKeluarState();
}

FireStoreDatabase database = FireStoreDatabase();

class _HistoryKeluarState extends State<HistoryKeluar> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Color primaryColor = const Color.fromARGB(255, 21, 179, 190);
  String? currentUserName;

  @override
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
    User? user = _auth.currentUser;
    return Consumer<FireStoreDatabase>(
      builder: (context, database, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Scaffold(
            appBar: AppBar(
              title: Text('Riwayat Izin Keluar'),
              backgroundColor: primaryColor,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    if (currentUserName != null)
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Icon(Icons.person, size: 28, color: Colors.blue),
                            SizedBox(width: 1),
                            Text(
                              ' $currentUserName',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    StreamBuilder<QuerySnapshot>(
                      stream: database.getDataRecord(user: user?.uid),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        //Get data from snapshot
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Center(child: Text('Tidak ada izin keluar')),
                          );
                        } else {
                          final keluar = snapshot.data!.docs;

                          //Return as List from FireStore
                          return Expanded(
                            child: ListView.builder(
                              itemCount: keluar.length,
                              itemBuilder: (context, index) {
                                final item = keluar[index].data()
                                    as Map<String, dynamic>;
                                String jamKeluar = item['Jam Keluar'];
                                String jamMasuk = item['Jam Masuk'];
                                Timestamp? tanggal =
                                    item['TimeStamp'] as Timestamp?;
                                String nama = item.containsKey('nama')
                                    ? item['nama']
                                    : 'Nama tidak tersedia';

                                //display return
                                return NewHistoryTile(
                                  jamKeluar: jamKeluar,
                                  jamMasuk: jamMasuk,
                                  tanggal: tanggal ?? Timestamp.now(),
                                  nama: nama,
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
