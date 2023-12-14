// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:society_management/customWidgets/colors.dart';
import 'package:society_management/customWidgets/custom_textfield.dart';

class AddSociety extends StatefulWidget {
  static const id = "/addSociety";
  const AddSociety({super.key});

  @override
  State<AddSociety> createState() => _AddSocietyState();
}

class _AddSocietyState extends State<AddSociety> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _uniqueController = TextEditingController();
  final TextEditingController _societyNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _adminNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _roadNoController = TextEditingController();
  final TextEditingController _roadNameController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _plotNoController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  @override
  void dispose() {
    _uniqueController.dispose();
    _societyNameController.dispose();
    _emailController.dispose();
    _regNoController.dispose();
    _adminNameController.dispose();
    _contactNumberController.dispose();
    _emailIdController.dispose();
    _roadNoController.dispose();
    _roadNameController.dispose();
    _areaController.dispose();
    _plotNoController.dispose();
    _landmarkController.dispose();
    _sectorController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppBarColor),
          title: Text(
            "Add Society",
            style: TextStyle(color: AppBarColor),
          ),
          backgroundColor: AppBarBgColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      color: AppBarColor,
                    ),
                    onPressed: () {
                      // signOut();
                    },
                  ),
                  Text(
                    'Hi, ${FirebaseAuth.instance.currentUser?.email}',
                    style: TextStyle(color: AppBarColor),
                  ),
                ],
              ),
            )
          ],
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
                        OverviewField('Unique ID: ', _uniqueController),
                        OverviewField('Reg No.: ', _regNoController),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Society Email: ', _emailController),
                        OverviewField('Admin Name: ', _adminNameController),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Admin Email: ', _emailIdController),
                        OverviewField(
                            'Admin Contact: ', _contactNumberController),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Road No.: ', _roadNoController),
                        OverviewField('Road Name: ', _roadNameController),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Area: ', _areaController),
                        OverviewField('Plot No.: ', _plotNoController),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Sector: ', _sectorController),
                        OverviewField('Landmark: ', _landmarkController),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Pincode: ', _pincodeController),
                        OverviewField('City: ', _cityController),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('State: ', _stateController),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, perform desired action
                      FirebaseFirestore.instance
                          .collection('society')
                          .doc(_societyNameController.text)
                          .set({
                        'uniqueId': _uniqueController.text,
                        'societyName': _societyNameController.text,
                        'regNo': _regNoController.text,
                        'email': _emailController.text,
                        'adminName': _adminNameController.text,
                        'contactNumber': _contactNumberController.text,
                        'emailId': _emailIdController.text,
                        'roadNo': _roadNoController.text,
                        'roadName': _roadNameController.text,
                        'area': _areaController.text,
                        'plotNo': _plotNoController.text,
                        'landmark': _landmarkController.text,
                        'sector': _sectorController.text,
                        'city': _cityController.text,
                        'state': _stateController.text,
                        'pincode': _pincodeController.text,
                      });
                      _uniqueController.clear();
                      _societyNameController.clear();
                      _regNoController.clear();
                      _emailController.clear();
                      _adminNameController.clear();
                      _contactNumberController.clear();
                      _emailIdController.clear();
                      _roadNoController.clear();
                      _roadNameController.clear();
                      _areaController.clear();
                      _plotNoController.clear();
                      _landmarkController.clear();
                      _sectorController.clear();
                      _cityController.clear();
                      _stateController.clear();
                      _pincodeController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      );

  // ignore: non_constant_identifier_names
  OverviewField(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            width: 250,
            child: CustomTextField(
              readonly: false,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
