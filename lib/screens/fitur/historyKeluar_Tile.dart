import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewHistoryTile extends StatefulWidget {
  final String jamKeluar;
  final String jamMasuk;
  final Timestamp tanggal;
  final String nama;

  const NewHistoryTile({
    super.key,
    required this.jamKeluar,
    required this.jamMasuk,
    required this.tanggal,
    required this.nama,
  });

  @override
  State<NewHistoryTile> createState() => _NewHistoryTileState();
}

class _NewHistoryTileState extends State<NewHistoryTile> {
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
    String formatTimestamp(Timestamp timestamp) {
      DateTime dateTime = timestamp.toDate();
      return DateFormat('dd-MM-yyyy').format(dateTime);
    }

    // Parse jamMasuk to TimeOfDay
    TimeOfDay jamMasukTime = TimeOfDay(
      hour: int.parse(widget.jamMasuk.split(':')[0]),
      minute: int.parse(widget.jamMasuk.split(':')[1]),
    );

    // Menentukan batas jam malam
    TimeOfDay batasKembali = TimeOfDay(hour: 20, minute: 0);

    // Menjadikan tampilan jamMasuk yang melebihi jam 20.00 berwarna merah
    Color jamMasukColor = (jamMasukTime.hour > batasKembali.hour ||
            (jamMasukTime.hour == batasKembali.hour &&
                jamMasukTime.minute > batasKembali.minute))
        ? Colors.red
        : Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 7),

      //Page Column
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama : ${widget.nama}'),
          Text(
            'Tanggal : ${formatTimestamp(widget.tanggal)}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),

          // Card container
          Container(
            // Card Decoration
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              color: Color.fromARGB(255, 226, 237, 241),
            ),

            // Data inside card decoration
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),

              //Column 1
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Jam Keluar  :',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),

                      // Display
                      const SizedBox(height: 6),
                      Text(
                        widget.jamKeluar,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ), // End Column 1

                  //Column 2
                  const SizedBox(width: 32),
                  Column(
                    children: [
                      Text(
                        'Jam Masuk  : ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),

                      // Display namaKegiatancontroller
                      const SizedBox(height: 6),
                      Text(
                        widget.jamMasuk,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: jamMasukColor,
                        ),
                      ),
                    ],
                  ), // End Column
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
