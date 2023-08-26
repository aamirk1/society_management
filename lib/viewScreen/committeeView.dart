// ignore_for_file: dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_management/listScreen/custom_textfield.dart';

class committeeDetails extends StatefulWidget {
  final String name;
  committeeDetails({super.key, required this.name});

  @override
  State<committeeDetails> createState() => _committeeDetailsState();
}

class _committeeDetailsState extends State<committeeDetails> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _societyNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _flatNoController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          backgroundColor: Colors.blueGrey.shade700,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      readOnly: true,
                      controller: _societyNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          labelText: 'Society Name',
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a society name';
                        }
                        return null;
                      },
                    ),
                  ),
                ]),
                Column(
                  children: [
                    Row(
                      children: [
                        OverviewField('Name: ', _nameController, true),
                        OverviewField('Flat No.: ', _flatNoController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField(
                            'Designation: ', _designationController, true),
                        OverviewField('Number: ', _numberController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Email: ', _emailController, true),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );

  OverviewField(String title, TextEditingController controller, bool readonly) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 200,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            width: 250,
            child: CustomTextField(
              readonly: readonly,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('committee')
        .doc(widget.name)
        .get();

    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    _nameController.text = data['name'] ?? 'Not Available';
    _flatNoController.text = data['flatNo'] ?? 'Not Available';
    _societyNameController.text = data['societyName'] ?? 'Not Available';
    _designationController.text = data['designation'] ?? 'Not Available';
    _emailController.text = data['email'] ?? 'Not Available';
    _numberController.text = data['number'] ?? 'Not Available';
  }
}
