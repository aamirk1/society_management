import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_management/authentication/loginScreen.dart';
import 'package:society_management/listScreen/committeeList.dart';
import 'package:society_management/listScreen/societyList.dart';
import 'package:society_management/provider/excel_provider.dart';
import 'package:society_management/provider/filteration_provider.dart';
import 'package:society_management/provider/menuUserPageProvider.dart';
import 'package:society_management/screen/AddBill.dart';
import 'package:society_management/screen/AddCommittee.dart';
import 'package:society_management/screen/AddMember.dart';
import 'package:society_management/screen/AddSociety.dart';
import 'package:society_management/viewScreen/side.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExcelProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => MenuUserPageProvider()),
      ],
      child: MaterialApp(
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
            primaryIconTheme: const IconThemeData(
              color: Color.fromARGB(255, 91, 3, 255),
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
          // home: const customSide()
          home: LoginScreen(),

          ),
    );
  }

  Widget? _getPageWidget(RouteSettings settings) {
    if (settings.name == null) {
      return null;
    }
    final uri = Uri.parse(settings.name!);
    switch (uri.path) {
      case '/':
        return LoginScreen();
      case '/addSociety':
        return const AddSociety();
      case '/addCommittee':
        return const AddCommittee();
      case '/addMember':
        return const AddMember();
      case '/societyList':
        return const societyList();
      case '/committeeList':
        return const committeeList();
      case '/addBill':
        return const AddBill();
    }

    return null;
  }
}
