// ignore: duplicate_ignore
// ignore_for_file: file_names
//ignore: avoid_web_libraries_in_flutter
// ignore: avoid_web_libraries_in_flutter, unused_import
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:society_management/customWidgets/colors.dart';
import 'package:society_management/excel/uploadExcelBillReceipt.dart';
import 'package:society_management/listScreen/Receipt/MemberBillReceipt.dart';

// import 'ListOfMemberName.dart';

// ignore: camel_case_types
class ListOfBillReceipt extends StatefulWidget {
  static const id = "/ListOfBillReceipt";
  const ListOfBillReceipt({super.key});

  @override
  State<ListOfBillReceipt> createState() => _ListOfBillReceiptState();
}

// ignore: camel_case_types
class _ListOfBillReceiptState extends State<ListOfBillReceipt> {
  final TextEditingController _societyNameController = TextEditingController();
  final TextEditingController monthyear = TextEditingController();

  List<List<dynamic>> data = [];
  // ignore: non_constant_identifier_names
  List<DataColumn> CustomDataColumn = [];
  List<String> searchedList = [];
  List<String> dateList = [];
  List<dynamic> columnName = [];
  @override
  void initState() {
    // print('hellolo $getBillMonth');
    // print(searchedList);
    // print('Month Year---$dateList');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text(
        //   "Society List",
        //   style: TextStyle(color: Colors.black),
        // ),
        backgroundColor: AppBarBgColor,
        actions: [
          Flexible(
              child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 10.0),
            child: Row(
              children: [
                 Text(
                  "Receipts",
                  style: TextStyle(color:AppBarColor, fontSize: 20),
                ),
                Container(
                  width: 550,
                  padding: const EdgeInsets.all(8),
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: _societyNameController,
                        style: DefaultTextStyle.of(context)
                            .style
                            .copyWith(fontStyle: FontStyle.italic),
                        decoration: const InputDecoration(
                            labelText: 'Selcet Society',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MemberBillReceipt(
                                  societyName: suggestion.toString(),
                                )),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: ElevatedButton(
                      style: const ButtonStyle(),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UpExcelBillReceipt()),
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
          )),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              children: [
                IconButton(
                  icon:  Icon(
                    Icons.person,
                    color:AppBarColor,
                  ),
                  onPressed: () {
                    // signOut();
                  },
                ),
                Text(
                  'Hi, ${FirebaseAuth.instance.currentUser?.email}',
                  style:  TextStyle(color:AppBarColor),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ladgerReceipt')
              .snapshots(),
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
                  const SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: societyList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(societyList[index],
                            style:  TextStyle(color:Colors.black)),
                        // subtitle: Text(data.docs[index]['city']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MemberBillReceipt(
                                societyName: societyList[index],
                              ),
                            ),
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
        await FirebaseFirestore.instance.collection('ladgerReceipt').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();
    // ignore: avoid_print
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
          .collection('ladgerReceipt')
          .doc(_societyNameController.text)
          .collection('tableData')
          .doc('$i')
          .set({
        'societyName': _societyNameController.text,
        '$i': data[i],
      }).then((value) {
        // ignore: avoid_print
        print('Done!');
      });
    }
  }

  // ignore: non_constant_identifier_names
  Future<List<DataRow>> getExceldata(String SelectedSociety) async {
    // ignore: non_constant_identifier_names
    List<DataRow> CustomDataRow = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ladgerReceipt')
        .doc(SelectedSociety)
        .collection('tableData')
        .get();
    List<dynamic> tableList = querySnapshot.docs.map((e) => e.id).toList();
    for (int i = 0; i < tableList.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('ladgerReceipt')
          .doc(SelectedSociety)
          .collection('tableData')
          .doc('$i')
          .get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      // ignore: unused_local_variable
      List<dynamic> tempList = data['$i'];
      // print('templist - $tempList');
      // CustomDataRow.add(row);
    }
    // print(CustomDataRow);
    return CustomDataRow;
  }

  getMonthReceipt(String pattern) async {
    dateList.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ladgerReceipt')
        .doc(_societyNameController.text)
        .collection('month')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();
    // print(tempList);

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        dateList.add(tempList[i]);
      } else {
        dateList.add('Not Availabel');
      }
    }
    // print(searchedList.length);
    return dateList;
  }
}
