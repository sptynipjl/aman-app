import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DaftarSantriTile extends StatefulWidget {
  final String Email;
  final String Password;
  final String nama;
  final String nis;
  final String kamar;
  final String angkatan;
  final String alamat;

  const DaftarSantriTile({
    super.key,
    required this.Email,
    required this.Password,
    required this.nama,
    required this.nis,
    required this.kamar,
    required this.angkatan,
    required this.alamat,
  });

  @override
  State<DaftarSantriTile> createState() => _DaftarSantriTileState();
}

class _DaftarSantriTileState extends State<DaftarSantriTile> {
  int hexColor(String color) {
    //adding prefix
    // ignore: prefer_interpolation_to_compose_strings
    String newColor = '0xff' + color;
    //removing # sign
    newColor = newColor.replaceAll('#', '');
    // convert into integer
    int finalColor = int.parse(newColor);
    return finalColor;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 7),

      //Page Column
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama : ${widget.nama}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          // Card container
          Container(
            width: double.infinity,
            height: 170,
            // Card Decoration
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              color: Color(hexColor('#F0F0F0')),
            ),

            // Data inside card decoration
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),

              //Column 1
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email          : ${widget.Email}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(hexColor('2D2D2D')),
                    ),
                  ),
                  Text(
                    'Password   : ${widget.Password}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(hexColor('2D2D2D')),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'NIS              : ${widget.nis}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(hexColor('2D2D2D')),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Angkatan   : ${widget.angkatan}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(hexColor('2D2D2D')),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Kamar        : ${widget.kamar}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(hexColor('2D2D2D')),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Alamat       : ${widget.alamat}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(hexColor('2D2D2D')),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
