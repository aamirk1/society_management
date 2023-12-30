// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_management/customWidgets/colors.dart';
import 'package:society_management/customWidgets/custom_textfield.dart';

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
  final TextEditingController uniqueController = TextEditingController();
  final TextEditingController societyNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController regNoController = TextEditingController();
  final TextEditingController adminNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController roadNoController = TextEditingController();
  final TextEditingController roadNameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController plotNoController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController sectorController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppBarColor),
          title: Text(widget.societyNames),
          backgroundColor: AppBarBgColor,
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
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      readOnly: true,
                      controller: societyNameController,
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
                        OverviewField('Unique ID: ', uniqueController, true),
                        OverviewField('Reg No.: ', regNoController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField(
                            'Society Email: ', emailController, false),
                        OverviewField(
                            'Admin Name: ', adminNameController, false),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField(
                            'Admin Email: ', emailIdController, false),
                        OverviewField(
                            'Admin Contact: ', contactNumberController, false),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Road No.: ', roadNoController, true),
                        OverviewField('Road Name: ', roadNameController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Area: ', areaController, true),
                        OverviewField('Plot No.: ', plotNoController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Sector: ', sectorController, true),
                        OverviewField('Landmark: ', landmarkController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('Pincode: ', pincodeController, true),
                        OverviewField('City: ', cityController, true),
                      ],
                    ),
                    Row(
                      children: [
                        OverviewField('State: ', stateController, true),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Form is valid, perform desired action
                          updateData(
                            uniqueController.text,
                            societyNameController.text,
                            regNoController.text,
                            emailController.text,
                            adminNameController.text,
                            contactNumberController.text,
                            emailIdController.text,
                            roadNoController.text,
                            roadNameController.text,
                            areaController.text,
                            plotNoController.text,
                            landmarkController.text,
                            sectorController.text,
                            cityController.text,
                            stateController.text,
                            pincodeController.text,
                          );
                        }
                      },
                      child: const Text('Update Details'),
                    ),
                  ),
                ),
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
    adminNameController.text = data['adminName'] ?? 'Not Available';
    uniqueController.text = data['uniqueId'] ?? 'Not Available';
    societyNameController.text = data['societyName'] ?? 'Not Available';
    regNoController.text = data['regNo'] ?? 'Not Available';
    emailController.text = data['email'] ?? 'Not Available';
    contactNumberController.text = data['contactNumber'];
    emailIdController.text = data['emailId'] ?? 'Not Available';
    roadNoController.text = data['roadNo'] ?? 'Not Available';
    roadNameController.text = data['roadName'] ?? 'Not Available';
    areaController.text = data['area'] ?? 'Not Available';
    plotNoController.text = data['plotNo'] ?? 'Not Available';
    landmarkController.text = data['landmark'] ?? 'Not Available';
    sectorController.text = data['sector'] ?? 'Not Available';
    cityController.text = data['city'] ?? 'Not Available';
    stateController.text = data['state'] ?? 'Not Available';
    pincodeController.text = data['pincode'] ?? 'Not Available';
  }

  Future<void> updateData(
      uniqueId,
      societyName,
      regNo,
      email,
      adminName,
      contactNumber,
      emailId,
      roadNo,
      roadName,
      area,
      plotNo,
      landmark,
      sector,
      city,
      state,
      pincode) async {
    FirebaseFirestore.instance
        .collection('society')
        .doc(societyNameController.text)
        .update({
      'uniqueId': uniqueId,
      'societyName': societyName,
      'regNo': regNo,
      'email': email,
      'adminName': adminName,
      'contactNumber': contactNumber,
      'emailId': emailId,
      'roadNo': roadNo,
      'roadName': roadName,
      'area': area,
      'plotNo': plotNo,
      'landmark': landmark,
      'sector': sector,
      'city': city,
      'state': state,
      'pincode': pincode,
    });
    uniqueController.clear();
    societyNameController.clear();
    regNoController.clear();
    emailController.clear();
    adminNameController.clear();
    contactNumberController.clear();
    emailIdController.clear();
    roadNoController.clear();
    roadNameController.clear();
    areaController.clear();
    plotNoController.clear();
    landmarkController.clear();
    sectorController.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
    Navigator.pop(context);
  }
}
