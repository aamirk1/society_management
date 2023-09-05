import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:society_management/listScreen/custom_textfield.dart';

class AddCommittee extends StatefulWidget {
  static const id = "/addCommittee";
  AddCommittee({super.key});

  @override
  State<AddCommittee> createState() => _AddCommitteeState();
}

class _AddCommitteeState extends State<AddCommittee> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _societyNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _flatNoController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  List<String> searchedList = [];

  @override
  void dispose() {
    _societyNameController.dispose();
    _nameController.dispose();
    _flatNoController.dispose();
    _designationController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Committee"),
        backgroundColor: Color.fromARGB(255, 0, 119, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          controller: _societyNameController,
                          decoration: const InputDecoration(
                              labelText: 'Select Society',
                              border: OutlineInputBorder())),
                      suggestionsCallback: (pattern) async {
                        return await getUserdata(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion.toString()),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        _societyNameController.text = suggestion.toString();
                      },
                    ),
                  )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      OverviewField('Name: ', _nameController),
                    ],
                  ),
                  Row(
                    children: [
                      OverviewField('Flat No.: ', _flatNoController),
                    ],
                  ),
                  Row(
                    children: [
                      OverviewField('Designation: ', _designationController),
                    ],
                  ),
                  Row(
                    children: [
                      OverviewField('Number: ', _numberController),
                    ],
                  ),
                  Row(
                    children: [
                      OverviewField('Email: ', _emailController),
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
            FirebaseFirestore.instance
                .collection('committee')
                .doc(_nameController.text)
                .set({
              'societyName': _societyNameController.text,
              'name': _nameController.text,
              'flatNo': _flatNoController.text,
              'designation': _designationController.text,
              'number': _numberController.text,
              'email': _emailController.text
            });

            // Perform desired action with the form data

            _societyNameController.clear();
            _nameController.clear();
            _flatNoController.clear();
            _designationController.clear();
            _numberController.clear();
            _emailController.clear();
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  getUserdata(String pattern) async {
    searchedList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('society').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();
    // print(tempList);

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        searchedList.add(tempList[i]);
      }
    }
    print(searchedList.length);
    return searchedList;
  }

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
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(
            width: 450,
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
