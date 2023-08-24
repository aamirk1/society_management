import 'package:flutter/material.dart';

class societyList extends StatefulWidget {
  const societyList({super.key});

  @override
  State<societyList> createState() => _societyListState();
}

class _societyListState extends State<societyList> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      body: Text('Society List'),
    ));
  }
}
