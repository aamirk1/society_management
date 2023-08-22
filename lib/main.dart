import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:society_management/screen/AddCommittee.dart';
import 'package:society_management/screen/AddMember.dart';
import 'package:society_management/screen/AddSociety.dart';
import 'package:society_management/screen/HomeScreen.dart';
import 'package:society_management/screen/Sidebar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBTEp34Y0CbkceRElxrh5Y9DNNnF7HwzoE",
          authDomain: "societymanagement-763f1.firebaseapp.com",
          projectId: "societymanagement-763f1",
          storageBucket: "societymanagement-763f1.appspot.com",
          messagingSenderId: "1077685961456",
          appId: "1:1077685961456:web:fbb4b365abf36459747835",
          measurementId: "G-3EHV4L3XZJ"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Society Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.blueGrey,
            ),
        primaryTextTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.purple,
            ),
        primaryIconTheme: IconThemeData(
          color: Colors.blueGrey,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (settings) {
        final page = _getPageWidget(settings);
        if (page != null) {
          return PageRouteBuilder(
              settings: settings,
              pageBuilder: (_, __, ___) => page,
              transitionsBuilder: (_, anim, __, child) {
                return FadeTransition(
                  opacity: anim,
                  child: child,
                );
              });
        }
        return null;
      },
      home: Sidebar(),
    );
  }

  Widget? _getPageWidget(RouteSettings settings) {
    if (settings.name == null) {
      return null;
    }
    final uri = Uri.parse(settings.name!);
    switch (uri.path) {
      case '/':
        return HomeScreen();
      case '/addSociety':
        return AddSociety();
      case '/addCommittee':
        return AddCommittee();
      case '/addMember':
        return const AddMember();
    }
    return null;
  }
}
