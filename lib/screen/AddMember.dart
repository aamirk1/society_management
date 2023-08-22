import 'package:flutter/material.dart';

class AddMember extends StatelessWidget {
  static const String id = "/addMember";
  const AddMember({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
      // appBar: AppBar(
      //   title: Text("Add Member"),
      //   backgroundColor: Colors.blueGrey.shade700,
      // ),
      body: Center(
          child: Text(
        "Add Member",
        style: TextStyle(fontSize: 20),
      )));
}
