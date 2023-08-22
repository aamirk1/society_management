import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  static const String id = '/';
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("Home"),
        //   backgroundColor: Colors.blueGrey.shade700,
        // ),
        body: Center(
            child: Text(
      "Home Page",
      style: TextStyle(fontSize: 20),
    )));
  }
}
