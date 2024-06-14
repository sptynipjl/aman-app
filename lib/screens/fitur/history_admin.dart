import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage(List list, {super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchIzinData() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('izin').get();
      List<Map<String, dynamic>> izinData = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      return izinData;
    } catch (e) {
      print("Error fetching izin data: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Izin Santri"),
        backgroundColor: const Color.fromARGB(255, 21, 179, 190),
      ),
      // body: FutureBuilder<List<Map<String, dynamic>>>(
      //   future: fetchIzinData(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text("Error fetching data"));
      //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      //       return Center(child: Text("No data available"));
      //     } else {
      //       List<Map<String, dynamic>> izinData = snapshot.data!;
      //       return ListView.builder(
      //         itemCount: izinData.length,
      //         itemBuilder: (context, index) {
      //           var data = izinData[index];
      //           return Card(
      //             margin: EdgeInsets.all(8.0),
      //             child: ListTile(
      //               title: Text(data['nama']),
      //               subtitle: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text("NIS: ${data['nis']}"),
      //                   Text("Jenis Izin: ${data['jenisIzin']}"),
      //                   Text("Tanggal: ${data['tanggal']}"),
      //                   Text("Alasan: ${data['alasan']}"),
      //                 ],
      //               ),
      //             ),
      //           );
      //         },
      //       );
      //     }
      //   },
      // ),
    );
  }
}

//Penjelasan:
// fetchIzinData Method:

// Mengambil data dari koleksi izin di Firestore.
// Mengubah data menjadi list of maps yang mudah digunakan dalam widget Flutter.
// FutureBuilder Widget:

// Menunggu data dari fetchIzinData.
// Menampilkan CircularProgressIndicator saat data sedang diambil.
// Menampilkan pesan kesalahan jika ada masalah saat mengambil data.
// Menampilkan pesan "No data available" jika tidak ada data.
// Menampilkan daftar data izin dalam bentuk kartu (Card).
// Firestore Data Structure:

// Pastikan koleksi Firestore Anda memiliki struktur yang sesuai dengan kode di atas. Misalnya, koleksi izin dengan dokumen yang memiliki field nis, nama, jenisIzin, tanggal, dan alasan.
// Dengan implementasi ini, halaman admin akan menampilkan riwayat izin keluar dan izin pulang dari seluruh santri yang diambil dari Firestore.
