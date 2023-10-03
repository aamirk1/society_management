import 'dart:html';

import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:society_management/listScreen/custom_textfield.dart';

// import '../excel/uploadExcel.dart';

class UpExcel extends StatefulWidget {
  static const String id = "/UpExcel";
  const UpExcel({super.key});

  @override
  State<UpExcel> createState() => _UpExcelState();
}

class _UpExcelState extends State<UpExcel> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _societyNameController = TextEditingController();
  // final TextEditingController s_flatNo = TextEditingController();
  // final TextEditingController s_name = TextEditingController();
  // final TextEditingController s_email = TextEditingController();
  // final TextEditingController s_mobile = TextEditingController();
  // final TextEditingController s_mc = TextEditingController();
  // final TextEditingController s_remarks = TextEditingController();
  // final TextEditingController s_parking = TextEditingController();
  // final TextEditingController s_tenant = TextEditingController();
  // final TextEditingController s_area = TextEditingController();
  // final TextEditingController s_status = TextEditingController();
  List<dynamic> columnName = [];
  List<String> searchedList = [];
  List<List<dynamic>> data = [];
  Map<String, dynamic> mapExcelData = Map();
  List<dynamic> alldata = [];
  Map<String, dynamic> fieldMap = {};
  List<dynamic> fielddata = [];

  bool showTable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Add Member",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 231, 239, 248),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
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
                        print(_societyNameController.text);
                      },
                    ),
                  )),
                ],
              ),
              // const SizedBox(
              //   height: 5,
              // ),

              // Column(
              //   children: [
              //     Row(
              //       children: [
              //         OverviewField('Flat No.: ', s_flatNo),
              //         OverviewField('Member Name: ', s_name),
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         OverviewField('Area', s_area),
              //         OverviewField('Status', s_status),
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         OverviewField('Mobile No.:', s_mobile),
              //         OverviewField(
              //           'Email Id:',
              //           s_email,
              //         ),
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         OverviewField('MC Member', s_mc),
              //         OverviewField('Remarks', s_remarks),
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         OverviewField('Parking No.', s_parking),
              //         OverviewField('Tenant Name And Address', s_tenant),
              //       ],
              //     ),
              //   ],
              // ),
              showTable
                  ? Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(2.0),
                        height: 398,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Expanded(
                            child: DataTable(
                              // border: const TableBorder(
                              //     horizontalInside: BorderSide(
                              //   color: Colors.black,
                              // )),
                              border: TableBorder.all(color: Colors.black),
                              headingRowColor:
                                  const MaterialStatePropertyAll(Colors.blue),
                              headingTextStyle: const TextStyle(
                                  color: Colors.white,
                                  // fontSize: 24,
                                  wordSpacing: 5),
                              columnSpacing: 5.0,
                              dataRowMinHeight: 10.0,
                              columns: columnName
                                  .map((e) => DataColumn(
                                        label: Text(
                                          e,
                                          // textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              // overflow: TextOverflow.ellipsis,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))
                                  .toList(),
                              rows: List.generate(
                                growable: true,
                                data.length,
                                (index1) => DataRow(
                                  cells: List.generate(
                                      growable: true, data[0].length, (index2) {
                                    return DataCell(Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Text(data[index1][index2]),

                                      // child: TextFormField(
                                      //     // controller: controllers[index1][index2],
                                      //     onChanged: (value) {
                                      //       data[index1][index2] = value;
                                      //     },
                                      //     decoration: InputDecoration(
                                      //         contentPadding: const EdgeInsets.only(
                                      //             left: 3.0, right: 3.0),
                                      //         border: const OutlineInputBorder(),
                                      //         hintText: data[index1][index2],
                                      //         hintStyle: const TextStyle(
                                      //             fontSize: 10.0,
                                      //             color: Colors.black))),
                                    ));
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              // SizedBox(height: 10),
              // Column(children: [
              //   Table(
              // children: [getdat()],
              //   ),
              // ]),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    ElevatedButton(
                        onPressed: selectExcelFile,
                        child: const Text(
                          "Upload Excel",
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // fieldMap['Flat No.: '] = s_flatNo.text;
          // fieldMap['Member Name: '] = s_name.text;
          // fieldMap['Area: '] = s_area.text;
          // fieldMap['Status: '] = s_status.text;
          // fieldMap['Mobile No.: '] = s_mobile.text;
          // fieldMap['Email Id: '] = s_email.text;
          // fieldMap['MC Member: '] = s_mc.text;
          // fieldMap['Remarks: '] = s_remarks.text;
          // fieldMap['Parking No: '] = s_parking.text;
          // fieldMap['Tenant Name And Address: '] = s_tenant.text;
          // fielddata.add(alldata);
          // fielddata.add(fieldMap);
          // // for (int i = 0; i < mapExcelData.length; i++) {
          // alldata.length != 0
          FirebaseFirestore.instance
              .collection('members')
              .doc(_societyNameController.text)
              .set({
            'data': alldata,
          }).then((value) {
            const ScaffoldMessenger(
                child: SnackBar(
              content: Text('Successfully Uploaded'),
            ));
          });
          // : FirebaseFirestore.instance
          //     .collection('members')
          //     .doc(_societyNameController.text)
          //     .set({'data': fielddata}).then((value) {
          //     const ScaffoldMessenger(
          //         child: SnackBar(
          //       content: Text('Successfully Uploaded'),
          //     ));
          //   });

          //       }
          // Perform desired action with the form data

          // _societyNameController.clear();
          // Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ));

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
    // print(searchedList.length);
    return searchedList;
  }

  Future<List<List<dynamic>>> selectExcelFile() async {
    final input = FileUploadInputElement()..accept = '.xlsx';
    input.click();

    await input.onChange.first;
    final files = input.files;

    if (files?.length == 1) {
      final file = files?[0];
      final reader = FileReader();

      reader.readAsArrayBuffer(file!);

      await reader.onLoadEnd.first;

      final excel = Excel.decodeBytes(reader.result as List<int>);

      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];

        for (var rows in sheet!.rows.skip(0)) {
          Map<String, dynamic> tempMap = {};
          if (columnName.isEmpty) {
            for (var cells in sheet.rows[0]) {
              columnName.add(cells!.value.toString());
            }
          }

          List<dynamic> rowData = [];
          for (var cell in rows) {
            rowData.add(cell?.value.toString() ?? '');
          }

          data.add(rowData);

          for (int i = 0; i < columnName.length; i++) {
            tempMap[columnName[i]] = rowData[i];
          }
          // mapExcelData.add(tempMap);
          alldata.add(tempMap);
          tempMap = {};
        }
        //   mapExcelData.removeAt(0);
        print(alldata);
      }

      data.removeAt(0);
      showTable = true;
      setState(() {});
    }
    return data;
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
