import 'package:aman/models/firebaseUser.dart';
import 'package:aman/screens/home/splash.dart';
import 'package:aman/screens/wrapper.dart';
import 'package:aman/services/auth.dart';
import 'package:aman/services/firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // untuk pengenalan gservices json
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser?>.value(
          value: AuthServices().user,
          initialData: null,
        ),
        Provider<FireStoreDatabase>(
          create: (_) => FireStoreDatabase(), // Buat instance FireStoreDatabase
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/', // Set initial route to splash screen
        routes: {
          '/': (context) => SplashScreen(),
          '/wrapper': (context) => const Wrapper(),
        },
        // home: const Wrapper(),
        navigatorObservers: [
          routeObserver
        ], // Tambahkan routeObserver ke navigatorObservers
      ),
    );
  }
}
