import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime parseDate(String dateString) {
  final parts = dateString.split('/');
  if (parts.length != 3) {
    throw FormatException('Invalid date format: $dateString');
  }
  final day = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final year = int.parse(parts[2]);
  return DateTime(year, month, day);
}

class HistoryTile extends StatefulWidget {
  final String tanggalPulang;
  final String tanggalKembali;
  final Timestamp tanggal;
  final String nama;
  final String? terlambat;

  const HistoryTile({
    super.key,
    required this.tanggalPulang,
    required this.tanggalKembali,
    required this.tanggal,
    required this.nama,
    this.terlambat,
  });

  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    // DateTime tanggalPulangDateTime = parseDate(widget.tanggalPulang);
    // DateTime tanggalKembaliDateTime = parseDate(widget.tanggalKembali);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 7),

      //Page Column
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama: ${widget.nama}'),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Tanggal Pulang  :',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),

                          // Display
                          const SizedBox(height: 6),
                          Text(
                            widget.tanggalPulang,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ), // End Column 1

                      //Column 2
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            'Tanggal Kembali  : ',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),

                          // Display namaKegiatancontroller
                          const SizedBox(height: 6),
                          Text(
                            widget.tanggalKembali,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ), // End Column
                    ],
                  ),
                  if (widget.terlambat != null)
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23),
                      ),
                      child: Text(
                        '${widget.terlambat}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
