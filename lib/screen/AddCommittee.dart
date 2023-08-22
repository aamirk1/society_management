import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:society_management/screen/AddSociety.dart';

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
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('TextFormField in a Single Row with Controller'),
      // ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              Flexible(
                  child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                    autofocus: true,
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontStyle: FontStyle.italic),
                    decoration: InputDecoration(border: OutlineInputBorder())),
                suggestionsCallback: (pattern) async {
                  return await getUserdata().getSuggestions(pattern);
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text('societyName'),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AddSociety()));
                },
              )),
              SizedBox(width: 16),
              Flexible(
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Name', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16),
              Flexible(
                child: TextFormField(
                  controller: _flatNoController,
                  decoration: InputDecoration(
                      labelText: 'Flat No.', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a flat number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16),
              Flexible(
                child: TextFormField(
                  controller: _designationController,
                  decoration: InputDecoration(
                      labelText: 'Designation', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a designation';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16),
              Flexible(
                child: TextFormField(
                  controller: _numberController,
                  decoration: InputDecoration(
                      labelText: 'Number', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a number';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16),
              Flexible(
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
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
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }

  getUserdata() async {
    searchedList.clear();
    FirebaseFirestore.instance.collection('society').get().then((value) {
      value.docs.forEach((element) {
        var data = element.data();
        searchedList.add(data['societyName']);
      });
    });

    print(searchedList.length);
    return searchedList;
  }
}
