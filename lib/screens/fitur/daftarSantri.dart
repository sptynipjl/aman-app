import 'package:aman/screens/fitur/daftarSantri_Tile.dart';
import 'package:aman/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class DaftarSantri extends StatefulWidget {
  @override
  _DaftarSantriState createState() => _DaftarSantriState();
}

class _DaftarSantriState extends State<DaftarSantri> {
  Color primary = const Color.fromARGB(255, 21, 179, 190);

  @override
  Widget build(BuildContext context) {
    return Consumer<FireStoreDatabase>(
      builder: (context, _database, child) => Scaffold(
        appBar: AppBar(
          title: Text('Daftar Nama Santri'),
          backgroundColor: primary,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('User').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    //Get data from snapshot
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Center(child: Text('Tidak ada data santri')),
                      );
                    } else {
                      final santri = snapshot.data!.docs;

                      //Return as List from FireStore
                      return Expanded(
                        child: ListView.builder(
                          itemCount: santri.length,
                          itemBuilder: (context, index) {
                            final item =
                                santri[index].data() as Map<String, dynamic>;
                            String Email = item.containsKey('Email')
                                ? item['Email']
                                : 'Email kosong';
                            String Password = item['Password'];
                            String nama = item.containsKey('nama')
                                ? item['nama']
                                : 'Nama tidak tersedia';
                            String nis = item.containsKey('nis')
                                ? item['nis']
                                : 'NIS tidak tersedia';
                            String kamar = item.containsKey('kamar')
                                ? item['kamar']
                                : 'Nama tidak tersedia';
                            String angkatan = item.containsKey('angkatan')
                                ? item['angkatan']
                                : 'Nama tidak tersedia';
                            String alamat = item.containsKey('alamat')
                                ? item['alamat']
                                : 'Nama tidak tersedia';

                            //display return
                            return DaftarSantriTile(
                              Email: Email,
                              Password: Password,
                              nama: nama,
                              nis: nis,
                              kamar: kamar,
                              angkatan: angkatan,
                              alamat: alamat,
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
    );

    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Admin Page'),
    //     ),
    //     body: StreamBuilder(
    //       stream: _database.getUsers(),
    //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //         if (!snapshot.hasData) {
    //           return Center(child: CircularProgressIndicator());
    //         }

    //         return ListView(
    //           children: snapshot.data!.docs.map((doc) {
    //             // Periksa jika field ada, jika tidak, berikan nilai default
    //             String nama = doc.data().containsKey('nama') ? doc['nama'] : 'Nama tidak tersedia';
    //             String email = doc.data().containsKey('email') ? doc['email'] : 'Email tidak tersedia';
    //             String nis = doc.data().containsKey('nis') ? doc['nis'] : 'NIS tidak tersedia';
    //             String kamar = doc.data().containsKey('kamar') ? doc['kamar'] : 'Kamar tidak tersedia';
    //             String password = doc.data().containsKey('password') ? doc['password'] : 'Password tidak tersedia';
    //             String angkatan = doc.data().containsKey('angkatan') ? doc['angkatan'] : 'Angkatan tidak tersedia';
    //             String alamat = doc.data().containsKey('alamat') ? doc['alamat'] : 'Alamat tidak tersedia';

    //             return ListTile(
    //               title: Text(nama),
    //               subtitle: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text('Email: $email'),
    //                   Text('NIS: $nis'),
    //                   Text('Kamar: $kamar'),
    //                   Text('Password: $password'),
    //                   Text('Angkatan: $angkatan'),
    //                   Text('Alamat: $alamat'),
    //                 ],
    //               ),
    //               trailing: IconButton(
    //                 icon: Icon(Icons.edit),
    //                 onPressed: () {
    //                   _editUser(context, doc, nama, email, nis, kamar, password, angkatan, alamat);
    //                 },
    //               ),
    //             );
    //           }).toList(),
    //         );
    //       },
    //     ),
    //   );
    // }

    // void _editUser(BuildContext context, QueryDocumentSnapshot doc, String nama, String email, String nis, String kamar, String password, String angkatan, String alamat) {
    //   final _namaController = TextEditingController(text: nama);
    //   final _emailController = TextEditingController(text: email);
    //   final _nisController = TextEditingController(text: nis);
    //   final _kamarController = TextEditingController(text: kamar);
    //   final _passwordController = TextEditingController(text: password);
    //   final _angkatanController = TextEditingController(text: angkatan);
    //   final _alamatController = TextEditingController(text: alamat);

    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text('Edit User'),
    //         content: SingleChildScrollView(
    //           child: Column(
    //             children: [
    //               TextField(
    //                 controller: _namaController,
    //                 decoration: InputDecoration(labelText: 'Nama'),
    //               ),
    //               TextField(
    //                 controller: _emailController,
    //                 decoration: InputDecoration(labelText: 'Email'),
    //               ),
    //               TextField(
    //                 controller: _nisController,
    //                 decoration: InputDecoration(labelText: 'NIS'),
    //               ),
    //               TextField(
    //                 controller: _kamarController,
    //                 decoration: InputDecoration(labelText: 'Kamar'),
    //               ),
    //               TextField(
    //                 controller: _passwordController,
    //                 decoration: InputDecoration(labelText: 'Password'),
    //               ),
    //               TextField(
    //                 controller: _angkatanController,
    //                 decoration: InputDecoration(labelText: 'Angkatan'),
    //               ),
    //               TextField(
    //                 controller: _alamatController,
    //                 decoration: InputDecoration(labelText: 'Alamat'),
    //               ),
    //             ],
    //           ),
    //         ),
    //         actions: [
    //           TextButton(
    //             onPressed: () => Navigator.pop(context),
    //             child: Text('Cancel'),
    //           ),
    //           TextButton(
    //             onPressed: () {
    //               _database.updateUser(
    //                 doc.id,
    //                 _namaController.text,
    //                 _emailController.text,
    //                 _nisController.text,
    //                 _kamarController.text,
    //                 _passwordController.text,
    //                 _angkatanController.text,
    //                 _alamatController.text,
    //               );
    //               Navigator.pop(context);
    //             },
    //             child: Text('Save'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }
}
