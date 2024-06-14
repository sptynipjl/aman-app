import 'package:aman/screens/fitur/historyPulang_Tile.dart';
import 'package:aman/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPulangAdmin extends StatefulWidget {
  final List<String> pulangList;

  const HistoryPulangAdmin(this.pulangList, {Key? key}) : super(key: key);

  @override
  State<HistoryPulangAdmin> createState() => _HistoryPulangAdminState();
}

FireStoreDatabase database = FireStoreDatabase();

class _HistoryPulangAdminState extends State<HistoryPulangAdmin> {
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
    return Consumer<FireStoreDatabase>(
      builder: (context, database, child) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Scaffold(
            appBar: AppBar(
              title: Text('Riwayat Izin Pulang'),
              backgroundColor: primaryColor,
            ),
            body: SafeArea(
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
                    stream: database.getRecordPulang(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      //Get data from snapshot
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Center(child: Text('Tidak ada izin pulang')),
                        );
                      } else {
                        final pulang = snapshot.data!.docs;

                        //Return as List from FireStore
                        return Expanded(
                          child: ListView.builder(
                            itemCount: pulang.length,
                            itemBuilder: (context, index) {
                              final item =
                                  pulang[index].data() as Map<String, dynamic>;
                              String tanggalPulang = item['Tanggal Pulang'];
                              String tanggalKembali = item['Tanggal Kembali'];
                              Timestamp? tanggal =
                                  item['TimeStamp'] as Timestamp?;
                              String nama = item.containsKey('nama')
                                  ? item['nama']
                                  : 'Nama tidak tersedia';

                              //display return
                              return HistoryTile(
                                tanggalPulang: tanggalPulang,
                                tanggalKembali: tanggalKembali,
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
    );
  }
}
