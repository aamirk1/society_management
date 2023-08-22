import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _uniqueController.dispose();
    _societyNameController.dispose();
    _emailController.dispose();
    _regNoController.dispose();
    _adminNameController.dispose();
    _contactNumberController.dispose();
    _emailIdController.dispose();
    dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // appBar: AppBar(
        //   title: const Text("Add Society"),
        //   backgroundColor: Colors.blueGrey.shade700,
        // ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 16),
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: _uniqueController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                labelText: 'Unique Id',
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a unique id';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: TextFormField(
                            controller: _regNoController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                labelText: 'Reg No',
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a registration number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(11.0),
                //   child: Text(
                //     "Contact Person",
                //     style: TextStyle(fontSize: 20),
                //   ),
                // ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: _adminNameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                labelText: 'Admin Name',
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a admin name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: TextFormField(
                            controller: _contactNumberController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                                labelText: 'Contact Number',
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a contact number';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: TextFormField(
                            controller: _emailIdController,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                                labelText: 'Email Id',
                                border: OutlineInputBorder()),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Email Id';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
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
                'emailId': _emailIdController.text
              });
            }
          },
          child: const Icon(Icons.check),
        ),
      );
}
