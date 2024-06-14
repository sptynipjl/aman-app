import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TambahUser extends StatefulWidget {
  const TambahUser({super.key});

  @override
  State<TambahUser> createState() => _TambahUserState();
}

class _TambahUserState extends State<TambahUser> {
  bool _showhide = true;

  final _nis = TextEditingController();
  final _password = TextEditingController();
  final _nama = TextEditingController();
  final _angkatan = TextEditingController();
  final _noinduk = TextEditingController();
  final _kamar = TextEditingController();
  final _alamat = TextEditingController();

  Future<void> userRegister() async {
    try {
      UserCredential? userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _nis.text,
        password: _password.text,
      );

      await createUserDocument(userCredential);
      if (mounted) {
        _showSuccessDialog();
      }
    } on FirebaseAuthException catch (e) {
      print('Register Error $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Register gagal. Mohon coba lagi ya...')),
        );
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("User")
          .doc(userCredential.user!.email)
          .set({
        'Email': userCredential.user!.email,
        'Password': _password.text,
        'nama': _nama.text,
        'nis': _noinduk.text,
        'angkatan': _angkatan.text,
        'kamar': _kamar.text,
        'alamat': _alamat.text,
      });
    }
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 210, 252, 255),
          title: Text('Berhasil'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Santri baru berhasil ditambahkan.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                _nis.clear();
                _password.clear();
                _nama.clear();
                _noinduk.clear();
                _angkatan.clear();
                _kamar.clear();
                _alamat.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final nisField = TextFormField(
      controller: _nis,
      decoration: InputDecoration(hintText: "Masukkan Username"),
      autofocus: false,
    );

    final passwordField = TextFormField(
      obscureText: _showhide,
      controller: _password,
      decoration: InputDecoration(
        hintText: "Masukkan Kata Sandi",
        suffixIcon: IconButton(
          icon: Icon(_showhide ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _showhide = !_showhide;
            });
          },
        ),
      ),
      autofocus: false,
    );
    final nameField = TextFormField(
      controller: _nama,
      decoration: InputDecoration(hintText: "Masukkan Nama"),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Nama tidak boleh kosong';
        }
        return null;
      },
    );

    final addressField = TextFormField(
      controller: _alamat,
      decoration: InputDecoration(hintText: "Masukkan Alamat"),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Alamat tidak boleh kosong';
        }
        return null;
      },
    );

    final roomField = TextFormField(
      controller: _kamar,
      decoration: InputDecoration(hintText: "Masukkan Kamar"),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Kamar tidak boleh kosong';
        }
        return null;
      },
    );

    final yearField = TextFormField(
      controller: _angkatan,
      decoration: InputDecoration(hintText: "Masukkan Angkatan"),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Angkatan tidak boleh kosong';
        }
        return null;
      },
    );

    final noindukField = TextFormField(
      controller: _noinduk,
      decoration: InputDecoration(hintText: "Masukkan NIS"),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Angkatan tidak boleh kosong';
        }
        return null;
      },
    );

    final registerButton = Material(
      shape: StadiumBorder(),
      color: Color.fromARGB(255, 19, 165, 175),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        onPressed: () async {
          userRegister();
        },
        child: Text(
          "Tambahkan Santri Baru",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Tambah Santri"),
        backgroundColor: Color.fromARGB(255, 19, 165, 175),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Image.asset('assets/images/logo_aman.png'),
                        width: 150,
                        height: 150,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Fitur Tertutup Departemen Keamanan",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Gunakan NIS dan buatlah password untuk registrasi santri baru sebagai user",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 10),
                      nisField,
                      passwordField,
                      nameField,
                      noindukField,
                      yearField,
                      roomField,
                      addressField,
                      SizedBox(height: 20),
                      registerButton,
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
