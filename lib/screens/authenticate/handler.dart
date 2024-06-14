import 'package:aman/screens/authenticate/login.dart';
import 'package:flutter/material.dart';

class Handler extends StatefulWidget {
  const Handler({Key? key}) : super(key: key);

  @override
  State<Handler> createState() => _HandlerState();
}

class _HandlerState extends State<Handler> {
  bool showSignIn =
      true; //membaca apakah yg kita klik menuju login atau register

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return Login(
        toggleView: toggleView,
      );
    } else {
      return AlertDialog(
        title: Text('Peringatan'),
        content: Text(
            'Gunakan NIS dan password yang telah diberikan Departemen Keamanan'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Nggih'),
          ),
        ],
      );
    }
  }
}
