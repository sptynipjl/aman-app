import 'package:aman/screens/home/admin.dart';
import 'package:aman/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final Function? toggleView;
  final Function()? onTap;

  const Login({Key? key, this.toggleView, this.onTap}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _showhide = true;
  bool isAdminLoggedIn = false;

  final _nis = TextEditingController();
  final _password = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  Color primary = const Color.fromARGB(255, 8, 134, 143);

  @override
  void initState() {
    super.initState();
    checkLoggedInUser();
  }

  Future<void> checkLoggedInUser() async {
    bool isLoggedIn = await isUserLoggedIn();
    setState(() {
      isAdminLoggedIn = isLoggedIn;
    });
  }

  Future<bool> isUserLoggedIn() async {
    return isAdminLoggedIn;
  }

  void userLogIn() async {
    if (!_validateFields()) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _nis.text,
        password: _password.text,
      );
      if (mounted) {
        Navigator.pop(context);
        if (_nis.text == 'pengurus@alamin-pbw.ac.id') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminMenu()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'Email tidak terdaftar';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Password salah';
      } else {
        errorMessage = 'Login Error: ${e.message}';
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Login Error: $e');

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Login Gagal! Username/Kata Sandi Mungkin Salah')),
        );
      }
    }
  }

  bool _validateFields() {
    String? nisError;
    String? passwordError;

    if (_nis.text.isEmpty) {
      nisError = 'Username tidak boleh kosong';
    } else if (!_nis.text.contains("@") ||
        !_nis.text.endsWith("alamin-pbw.ac.id")) {
      nisError = 'Tambahkan @alamin-pbw.ac.id setelah NIS';
    }

    if (_password.text.isEmpty) {
      passwordError = 'Password tidak boleh kosong';
    }
    if (nisError != null || passwordError != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(nisError ?? passwordError ?? 'Unknown error'),
          ),
        );
      }
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (isAdminLoggedIn) {
      return AdminMenu();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(""),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _globalKey,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Image.asset('assets/images/logo_aman.png'),
                        width: 190,
                        height: 190,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Selamat Datang!",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primary,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 3.0,
                              color: Colors.black26,
                            ),
                          ],
                          decorationColor: primary,
                          decorationStyle: TextDecorationStyle.solid,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        "Gunakan NIS dan password sesuai yang telah diberikan Departemen Keamanan!",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _nis,
                        decoration:
                            InputDecoration(hintText: "Masukkan Username"),
                        autofocus: false,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        obscureText: _showhide,
                        controller: _password,
                        decoration: InputDecoration(
                          hintText: "Masukkan Kata Sandi",
                          suffixIcon: IconButton(
                            icon: Icon(_showhide
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _showhide = !_showhide;
                              });
                            },
                          ),
                        ),
                        autofocus: false,
                      ),
                      SizedBox(height: 60),
                      ElevatedButton(
                        onPressed: () async {
                          userLogIn();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 19, 165, 175),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text("          Masuk          "),
                      ),
                      SizedBox(height: 70),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
