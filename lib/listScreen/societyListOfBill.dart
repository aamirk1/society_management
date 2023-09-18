import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:society_management/excel/uploadExcel.dart';
import 'package:society_management/excel/uploadExcelBill.dart';
import 'package:society_management/listScreen/ListOfMemberBill.dart';
import 'package:society_management/viewScreen/societyView.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'ListOfMemberName.dart';

class societyListOfBill extends StatefulWidget {
  static const id = "/societyListOfBill";
  societyListOfBill({super.key});

  @override
  State<societyListOfBill> createState() => _societyListOfBillState();
}

class _societyListOfBillState extends State<societyListOfBill> {
  final TextEditingController _societyNameController = TextEditingController();

  List<List<dynamic>> data = [];
  List<DataColumn> CustomDataColumn = [];
  List<String> searchedList = [];
  List<dynamic> columnName = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Society List",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromARGB(255, 231, 239, 248),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // signOut();
                  },
                ),
                Text(
                  'Hi, ${FirebaseAuth.instance.currentUser?.displayName}',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('accounts').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data;
              // String cityname = '';

              List<dynamic> societyList = data!.docs.map((e) => e.id).toList();

              return Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: Container(
                        padding: const EdgeInsets.all(8),
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _societyNameController,
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontStyle: FontStyle.italic),
                              decoration: const InputDecoration(
                                  labelText: 'Search Society',
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
                            print('help');
                            _societyNameController.text = suggestion.toString();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListOfMemberBill(
                                        societyName: suggestion.toString(),
                                      )),
                            );
                          },
                        ),
                      )),
                      const SizedBox(width: 10),
                      Container(
                        height: 45,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: ElevatedButton(
                            style: const ButtonStyle(),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const UpExcelBill()),
                              );
                            },
                            child: const Icon(
                              Icons.add,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: societyList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(societyList[index]),
                        // subtitle: Text(data.docs[index]['city']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListOfMemberBill(
                                      societyName: societyList[index],
                                    )),
                          );
                        },
                      );
                    },
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  getUserdata(String pattern) async {
    searchedList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('accounts').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();
    print(tempList);

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        searchedList.add(tempList[i]);
      }
    }
    // print(searchedList.length);
    return searchedList;
  }

  getdat() async {
    for (int i = 0; i < data.length; i++) {
      FirebaseFirestore.instance
          .collection('accounts')
          .doc(_societyNameController.text)
          .collection('tableData')
          .doc('$i')
          .set({
        'societyName': _societyNameController.text,
        '$i': data[i],
      }).then((value) {
        print('Done!');
      });
    }
  }

  Future<List<DataRow>> getExceldata(String SelectedSociety) async {
    List<DataRow> CustomDataRow = [];
    List<DataColumn> CustomDataColumn = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(SelectedSociety)
        .collection('tableData')
        .get();
    List<dynamic> tableList = querySnapshot.docs.map((e) => e.id).toList();
    print(tableList);
    for (int i = 0; i < tableList.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(SelectedSociety)
          .collection('tableData')
          .doc('$i')
          .get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> tempList = data['$i'];
      // print('templist - $tempList');
      // CustomDataRow.add(row);
    }
    // print(CustomDataRow);
    return CustomDataRow;
  }
}
