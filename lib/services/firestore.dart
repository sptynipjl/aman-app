import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreDatabase {
  User? user = FirebaseAuth.instance.currentUser;

  // Initiate Firestore instance
  final FirebaseFirestore _dataIzin = FirebaseFirestore.instance;

  // Initiate Collections
  final CollectionReference izin =
      FirebaseFirestore.instance.collection('Record');
  final CollectionReference users = FirebaseFirestore.instance
      .collection('User'); // Assuming 'User' is the correct collection name

  // Get the current user's name
  Future<String> getCurrentUserName() async {
    if (user == null) {
      throw Exception('User is not logged in');
    }

    DocumentSnapshot userDoc = await users.doc(user!.email).get();

    if (!userDoc.exists) {
      throw Exception('User document does not exist');
    }

    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

    if (userData == null || !userData.containsKey('nama')) {
      throw Exception('Field "nama" does not exist within the user document');
    }

    return userData['nama'];
  }

  // Post data izin
  Future<void> addDataIzin(String jamKeluar, String jamMasuk) async {
    try {
      String userName = await getCurrentUserName();

      await _dataIzin.collection('Record Keluar').add({
        'Jam Keluar': jamKeluar,
        'Jam Masuk': jamMasuk,
        'TimeStamp': FieldValue.serverTimestamp(),
        'userId': user?.uid,
        'nama': userName,
      });
    } catch (e) {
      print('Error adding izin data: $e');
    }
  }

  Future<void> addDataIzinPulang(
      String tanggalPulang, String tanggalKembali) async {
    try {
      String userName = await getCurrentUserName();

      await _dataIzin.collection('Record Pulang').add({
        'Tanggal Pulang': tanggalPulang,
        'Tanggal Kembali': tanggalKembali,
        'TimeStamp': FieldValue.serverTimestamp(),
        'userId': user?.uid,
        'nama': userName,
      });
    } catch (e) {
      print('Error adding izin pulang data: $e');
    }
  }

  Stream<QuerySnapshot> getDataRecord({String? user, DateTime? date}) {
    print('User ID: $user'); // Memantau nilai user
    Query query = _dataIzin
        .collection('Record Keluar')
        .orderBy('TimeStamp', descending: true);

    if (user != null) {
      print('Adding user filter');
      query = query.where('userId', isEqualTo: user);
    }

    print('Final query: $query');

    return query.snapshots();
  }
  // Stream<QuerySnapshot> getDataRecord({String? user, DateTime? date}) {
  //   return _dataIzin
  //       .collection('Record Keluar')
  //       .orderBy('TimeStamp', descending: true)
  //       .snapshots();
  //   // if (date != null) {
  //   //   DateTime startOfDay = DateTime(date.year, date.month, date.day);
  //   //   DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
  //   //   query = query.where('TimeStamp',
  //   //       isGreaterThanOrEqualTo: startOfDay, isLessThanOrEqualTo: endOfDay);
  //   // }
  // }

  Stream<QuerySnapshot> getRecordPulang({String? user, DateTime? date}) {
    print('User ID: $user');
    Query query = _dataIzin
        .collection('Record Pulang')
        .orderBy('TimeStamp', descending: true);

    if (user != null) {
      print('Adding user filter');
      query = query.where('userId', isEqualTo: user);
    }

    print('Final query: $query');
    return query.snapshots();
  }

  Stream<QuerySnapshot> getAllPermissions() {
    return _dataIzin
        .collection('Record Keluar')
        .orderBy('TimeStamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getUsers() {
    return users.snapshots();
  }

  Future<void> updateUser(String id, String nama, String email, String nis,
      String kamar, String password, String angkatan, String alamat) async {
    await users.doc(id).update({
      'nama': nama,
      'email': email,
      'nis': nis,
      'kamar': kamar,
      'password': password,
      'angkatan': angkatan,
      'alamat': alamat,
    });
  }
}
