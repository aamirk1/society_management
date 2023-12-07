// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_management/listScreen/custom_textfield.dart';

// ignore: camel_case_types
class societyDetails extends StatefulWidget {
  final String societyNames;
  const societyDetails({super.key, required this.societyNames});

  @override
  State<societyDetails> createState() => _societyDetailsState();
}

// ignore: camel_case_types
class _societyDetailsState extends State<societyDetails> {
  @override
  void initState() {
    getData();
    super.initState();
  }

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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          title: Text(widget.societyNames),
          backgroundColor: const Color.fromARGB(255, 0, 119, 255),
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
                        OverviewField('Unique ID: ', _uniqueController, true),
                        OverviewField('Reg No.: ', _regNoController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField(
                            'Society Email: ', _emailController, true),
                        OverviewField(
                            'Admin Name: ', _adminNameController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField(
                            'Admin Email: ', _emailIdController, true),
                        OverviewField(
                            'Admin Contact: ', _contactNumberController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Road No.: ', _roadNoController, true),
                        OverviewField('Road Name: ', _roadNameController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Area: ', _areaController, true),
                        OverviewField('Plot No.: ', _plotNoController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Sector: ', _sectorController, true),
                        OverviewField('Landmark: ', _landmarkController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Pincode: ', _pincodeController, true),
                        OverviewField('City: ', _cityController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('State: ', _stateController, true),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );

  // ignore: non_constant_identifier_names
  OverviewField(String title, TextEditingController controller, bool readonly) {
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
        .collection('society')
        .doc(widget.societyNames)
        .get();

    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    _adminNameController.text = data['adminName'] ?? 'Not Available';
    _uniqueController.text = data['uniqueId'] ?? 'Not Available';
    _societyNameController.text = data['societyName'] ?? 'Not Available';
    _regNoController.text = data['regNo'] ?? 'Not Available';
    _emailController.text = data['email'] ?? 'Not Available';
    _contactNumberController.text = data['contactNumber'];
    _emailIdController.text = data['emailId'] ?? 'Not Available';
    _roadNoController.text = data['roadNo'] ?? 'Not Available';
    _roadNameController.text = data['roadName'] ?? 'Not Available';
    _areaController.text = data['area'] ?? 'Not Available';
    _plotNoController.text = data['plotNo'] ?? 'Not Available';
    _landmarkController.text = data['landmark'] ?? 'Not Available';
    _sectorController.text = data['sector'] ?? 'Not Available';
    _cityController.text = data['city'] ?? 'Not Available';
    _stateController.text = data['state'] ?? 'Not Available';
    _pincodeController.text = data['pincode'] ?? 'Not Available';
  }
}
