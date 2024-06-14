import 'dart:async';
import 'dart:math';
import 'package:aman/main.dart';
import 'package:aman/screens/fitur/historyPulang.dart';
import 'package:aman/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IzinPulangPage extends StatefulWidget {
  const IzinPulangPage({Key? key}) : super(key: key);

  @override
  _IzinPulangPageState createState() => _IzinPulangPageState();
}

class _IzinPulangPageState extends State<IzinPulangPage> with RouteAware {
  List<String> pulangList = [];
  bool isPulang = false;
  late DateTime now;
  DateTime? startDate;
  DateTime? endDate;
  String tanggalPulang = "--/--/--";
  String tanggalKembali = "--/--/--";
  DateCounterController? dateCounterController;
  bool isLocationValid = true; // Variable to check location validity

  Color primary = const Color.fromARGB(255, 21, 179, 190);

  // Koordinat pondok dan radius dalam meter
  // -7.434628780006266, 109.25251014235464 (ittp lab FIF)
  // -7.3948409926071745, 109.24551570245471 (PPQ depan ndalem)
  // -7.394836337780554, 109.24555928835122 (PPQ meja piket)
  final double _pondokLatitude = -7.394836337780554;
  // -7.394734938176843; //latitude PPQ Al Amin Pabuaran
  final double _pondokLongitude = 109.24555928835122;
  // 109.24568359877377; //longitude PPQ Al Amin Pabuaran
  final double _radius =
      20.0; // Radius dalam meter yang diizinkan untuk dapat mengakses aplikasi

  Location location = new Location();

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    loadLastPermissionDate();
    _checkLocationPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      MyApp.routeObserver.subscribe(this, route as PageRoute<dynamic>);
    }
  }

  @override
  void dispose() {
    MyApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    setState(() {
      now = DateTime.now();
      tanggalPulang = startDate != null ? formatDate(startDate!) : "--/--/--";
      tanggalKembali = endDate != null ? formatDate(endDate!) : "--/--/--";
    });
  }

  void loadLastPermissionDate() async {
    final prefs = await SharedPreferences.getInstance();
    final startMillis = prefs.getInt('izin_start_date');
    final endMillis = prefs.getInt('izin_end_date');
    if (startMillis != null) {
      setState(() {
        startDate = DateTime.fromMillisecondsSinceEpoch(startMillis);
        if (endMillis != null) {
          endDate = DateTime.fromMillisecondsSinceEpoch(endMillis);
          tanggalKembali = formatDate(endDate!);
        }
        isPulang = true;
        tanggalPulang = formatDate(startDate!);
        dateCounterController = DateCounterController();
        dateCounterController?.start();
      });
    }
  }

  void saveLastPermissionDate() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('izin_start_date', startDate!.millisecondsSinceEpoch);
    if (endDate != null) {
      prefs.setInt('izin_end_date', endDate!.millisecondsSinceEpoch);
    }
  }

  void _toggleIzinPulang() async {
    if (isPulang) {
      // Check location before allowing to end Izin Pulang
      await _checkLocation();
      if (!isLocationValid) {
        _showLocationError();
        return;
      }
    }

    setState(() {
      now = DateTime.now(); // Update now
      if (!isPulang) {
        // Mulai Izin Pulang
        startDate = now;
        isPulang = true;
        tanggalPulang = formatDate(startDate!);
        saveLastPermissionDate();
        dateCounterController = DateCounterController();
        dateCounterController?.start();
      } else {
        // Akhiri Izin Pulang dan simpan hasil
        endDate = now;
        isPulang = false;
        tanggalKembali = formatDate(endDate!);
        dateCounterController?.stop();
        String totalTime = dateCounterController?.stop() ?? '-- days';
        int daysLate = dateCounterController!.daysLate();
        String historyEntry =
            'Tanggal Pulang: $tanggalPulang, Tanggal Kembali: $tanggalKembali, Durasi: $totalTime';
        if (daysLate > 0) {
          historyEntry += ', Terlambat: $daysLate hari';
        }
        addToHistory(historyEntry);
        clearLastPermissionDate();
      }
    });
  }

  void clearLastPermissionDate() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('izin_start_date');
    prefs.remove('izin_end_date');
  }

  FireStoreDatabase database = FireStoreDatabase();

  // Add data ke Firestore
  Future<void> addHistory() async {
    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Harap mulai dan selesaikan izin pulang terlebih dahulu!')),
      );
      return;
    }
    String formattedStartDate = formatDate(startDate!);
    String formattedEndDate = formatDate(endDate!);

    database.addDataIzinPulang(formattedStartDate, formattedEndDate);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HistoryPulang(pulangList)));
  }

  void _checkLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _checkLocation() async {
    LocationData _locationData = await location.getLocation();

    double distance = _calculateDistance(
      _locationData.latitude!,
      _locationData.longitude!,
      _pondokLatitude,
      _pondokLongitude,
    );

    setState(() {
      isLocationValid = distance <= _radius;
    });
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371e3; // Radius bumi dalam meter
    double phi1 = lat1 * (3.141592653589793 / 180);
    double phi2 = lat2 * (3.141592653589793 / 180);
    double deltaPhi = (lat2 - lat1) * (3.141592653589793 / 180);
    double deltaLambda = (lon2 - lon1) * (3.141592653589793 / 180);

    double a = (sin(deltaPhi / 2) * sin(deltaPhi / 2)) +
        (cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2));
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = R * c;
    return distance;
  }

  void _showLocationError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lokasi Tidak Valid'),
          content: Text(
              'Anda harus berada dalam radius yang diizinkan untuk kembali ke pondok.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Izin Pulang')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Hai, Santri yang Baik!"),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Hari Ini: ${now.day}-${now.month}-${now.year}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(tanggalPulang,
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white)),
                              Text("Tanggal Pulang",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          SizedBox(width: 50),
                          Column(
                            children: [
                              Text(tanggalKembali,
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white)),
                              Text("Tanggal Kembali",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _toggleIzinPulang,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor:
                      Color.fromARGB(255, 233, 175, 2), // foreground
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child:
                    Text(isPulang ? 'Kembali ke Pondok' : 'Mulai Izin Pulang'),
              ),
              SizedBox(height: 20),
              if (isPulang && dateCounterController != null)
                Text(dateCounterController!.stop()),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addHistory,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 8, 134, 143),
                  shadowColor: Colors.blueAccent,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                child: Text('Tambah ke Catatan Izin Pulang '),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addToHistory(String entry) {
    setState(() {
      pulangList.add(entry);
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}

class DateCounterController {
  late DateTime startTime;

  void start() {
    startTime = DateTime.now();
  }

  String stop() {
    DateTime endTime = DateTime.now();
    Duration difference = endTime.difference(startTime);
    int days = difference.inDays;
    return '$days days';
  }

  int daysLate() {
    DateTime endTime = DateTime.now();
    Duration difference = endTime.difference(startTime);
    int days = difference.inDays;
    return days > 1 ? days - 1 : 0;
  }
}

class HistoryPage extends StatelessWidget {
  final List<String> pulangList;

  const HistoryPage(this.pulangList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History')),
      body: ListView.builder(
        itemCount: pulangList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pulangList[index]),
          );
        },
      ),
    );
  }
}
