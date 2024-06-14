import 'dart:async';
import 'package:aman/main.dart';
import 'package:aman/screens/fitur/historyKeluar.dart';
import 'package:aman/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IzinKeluarPage extends StatefulWidget {
  const IzinKeluarPage({Key? key}) : super(key: key);

  @override
  _IzinKeluarPageState createState() => _IzinKeluarPageState();
}

class _IzinKeluarPageState extends State<IzinKeluarPage> with RouteAware {
  List<String> absenList = [];
  bool isAbsenKeluar = false;
  late DateTime now;
  DateTime? startTime;
  DateTime? endTime;
  String jamKeluar = "--:--";
  String jamMasuk = "--:--";
  TimeCounterController? timeCounterController;

  Color primary = const Color.fromARGB(255, 21, 179, 190);
  Color buttonColor = Color.fromARGB(255, 233, 175, 2);

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    loadLastPermissionTime();
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
      jamKeluar =
          startTime != null ? DateFormat.Hm().format(startTime!) : "--/--/--";
      jamMasuk =
          endTime != null ? DateFormat.Hm().format(endTime!) : "--/--/--";
    });
  }

// memuat waktu dari SharedPref
  void loadLastPermissionTime() async {
    final prefs = await SharedPreferences.getInstance();
    final startMillis = prefs.getInt('izin_start_time');
    final endMillis = prefs.getInt('izin_end_time');
    if (startMillis != null) {
      setState(() {
        startTime = DateTime.fromMillisecondsSinceEpoch(startMillis);
        if (endMillis != null) {
          endTime = DateTime.fromMillisecondsSinceEpoch(endMillis);
          jamMasuk = DateFormat.Hm().format(endTime!);
        }
        isAbsenKeluar = true;
        jamKeluar = DateFormat.Hm().format(startTime!);
        timeCounterController = TimeCounterController();
        timeCounterController?.start();
      });
    }
  }

// menyimpan waktu dari sharedpref
  void saveLastPermissionTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('izin_start_time', startTime!.millisecondsSinceEpoch);
    if (endTime != null) {
      prefs.setInt('izin_end_time', endTime!.millisecondsSinceEpoch);
    }
  }

  void _toggleIzinKeluar() {
    setState(() {
      now = DateTime.now();
      if (!isAbsenKeluar) {
        // Mulai Izin Keluar
        isAbsenKeluar = true;
        startTime = now;
        jamKeluar = DateFormat.Hm().format(startTime!);
        startAbsen('Izin Keluar');
        timeCounterController = TimeCounterController();
        saveLastPermissionTime();
        timeCounterController?.start();
        buttonColor = Color.fromARGB(255, 117, 211, 74);
      } else {
        // Akhiri Izin Keluar dan simpan hasil
        endTime = now;
        isAbsenKeluar = false;
        jamMasuk = DateFormat.Hm().format(endTime!);
        String totalTime = timeCounterController?.stop() ?? '--:--:--';
        addToHistory(
            'Jam Keluar: $jamKeluar, Jam Masuk: $jamMasuk, Durasi: $totalTime');
        clearLastPermissionTime();
        buttonColor = Color.fromARGB(255, 233, 175, 2);
      }
    });
  }

  void clearLastPermissionTime() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('izin_start_time');
    prefs.remove('izin_end_time');
  }

  FireStoreDatabase database = FireStoreDatabase();

  // Add data ke Firestore
  Future<void> addHistory() async {
    if (startTime == null || endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Harap mulai dan selesaikan izin keluar terlebih dahulu!')),
      );
      return;
    }

    String formattedStartTime = DateFormat.Hm().format(startTime!);
    String formattedEndTime = DateFormat.Hm().format(endTime!);

    database.addDataIzin(formattedStartTime, formattedEndTime);

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HistoryKeluar(absenList)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Izin Keluar'),
        backgroundColor: primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Hai, Santri Taat Aturan!"),
              SizedBox(height: 30),
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
                              Text(jamKeluar,
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white)),
                              Text("Jam Keluar",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          SizedBox(width: 50),
                          Column(
                            children: [
                              Text(jamMasuk,
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white)),
                              Text("Jam Masuk",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: _toggleIzinKeluar,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: buttonColor, // warna tombol yang dinamis
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Text(
                    isAbsenKeluar ? 'Kembali ke Pondok' : 'Mulai Izin Keluar'),
              ),
              SizedBox(height: 20),
              if (isAbsenKeluar && timeCounterController != null)
                TimeCounter(controller: timeCounterController!),
              SizedBox(height: 50),
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
                child: Text('Tambah ke Catatan Izin'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startAbsen(String label) {
    // Logika untuk memulai absen (bisa menambahkan ke database atau lainnya)
  }

  void addToHistory(String entry) {
    setState(() {
      absenList.add(entry);
    });
  }
}

class TimeCounterController {
  late Timer timer;
  int secondsPassed = 0;

  void start() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      secondsPassed++;
      saveTimeState();
    });
  }

  String stop() {
    timer.cancel();
    saveTimeState();
    int seconds = secondsPassed % 60;
    int minutes = (secondsPassed ~/ 60) % 60;
    int hours = secondsPassed ~/ (60 * 60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void saveTimeState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('seconds_passed', secondsPassed);
  }

  Future<void> loadTimeState() async {
    final prefs = await SharedPreferences.getInstance();
    secondsPassed = prefs.getInt('seconds_passed') ?? 0;
  }
}

class TimeCounter extends StatefulWidget {
  final TimeCounterController controller;

  const TimeCounter({Key? key, required this.controller}) : super(key: key);

  @override
  _TimeCounterState createState() => _TimeCounterState();
}

class _TimeCounterState extends State<TimeCounter> {
  late Timer _uiUpdateTimer;

  @override
  void initState() {
    super.initState();
    // Tidak perlu memulai timer di sini, karena sudah dimulai di controller
    _uiUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _uiUpdateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_getTimeString(), style: TextStyle(fontSize: 24));
  }

// Mengembalikan string waktu yang diformat
  String _getTimeString() {
    int seconds = widget.controller.secondsPassed % 60;
    int minutes = (widget.controller.secondsPassed ~/ 60) % 60;
    int hours = widget.controller.secondsPassed ~/ (60 * 60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
