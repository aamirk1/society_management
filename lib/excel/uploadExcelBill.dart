// ignore: duplicate_ignore
// ignore_for_file: file_names
//ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:society_management/customWidgets/colors.dart';

// import '../excel/uploadExcel.dart';

class UpExcelBill extends StatefulWidget {
  static const String id = "/UpExcelBill";
  const UpExcelBill({super.key});

  @override
  State<UpExcelBill> createState() => _UpExcelBillState();
}

class _UpExcelBillState extends State<UpExcelBill> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _societyNameController = TextEditingController();
  List<dynamic> columnName = [];
  List<String> searchedList = [];
  List<List<dynamic>> data = [];
  // ignore: prefer_collection_literals
  Map<String, dynamic> mapExcelData = Map();
  List<dynamic> alldata = [];
  String monthyear = DateFormat('MMMM yyyy').format(DateTime.now());

  bool showTable = false;

  @override
  void initState() {
    // print(monthyear);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Add Bill",
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
                            border: OutlineInputBorder()),
                      ),
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
                        // print(_societyNameController.text);
                      },
                    ),
                  )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              showTable
                  ? Container(
                      padding: const EdgeInsets.all(2.0),
                      height: 398,
                      width: MediaQuery.of(context).size.width,
                      child: DataTable2(
                        minWidth: 1700,
                        // border: const TableBorder(
                        //     horizontalInside: BorderSide(
                        //   color:AppBarColor,
                        // )),
                        border: TableBorder.all(color: Colors.black),
                        headingRowColor:
                            const MaterialStatePropertyAll(Colors.blue),
                        headingTextStyle: const TextStyle(
                            color: Colors.white,
                            // fontSize: 24,
                            wordSpacing: 5),
                        columnSpacing: 5.0,
                        columns: columnName
                            .map((e) => DataColumn2(
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
                          (index1) => DataRow2(
                            cells: List.generate(growable: true, data[0].length,
                                (index2) {
                              return DataCell(Padding(
                                padding: const EdgeInsets.only(bottom: 5.0),
                                child: Text(data[index1][index2]),
                              ));
                            }),
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
                height: 15,
              ),

              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: selectExcelFile,
                      child: const Text(
                        "Upload Excel",
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: openPdf(url),
                      child: const Text(
                        "Download CSV",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // for (int i = 0; i < mapExcelData.length; i++) {
          FirebaseFirestore.instance
              .collection('accounts')
              .doc(_societyNameController.text)
              .collection('month')
              .doc(monthyear)
              .set({
            'data': alldata,
          }).then((value) {
            const ScaffoldMessenger(
                child: SnackBar(
              content: Text('Successfully Uploaded'),
            ));
          });

          FirebaseFirestore.instance
              .collection('accounts')
              .doc(_societyNameController.text)
              .set({'name': _societyNameController.text});
          //       }
          // Perform desired action with the form data

          _societyNameController.clear();
          Navigator.pop(context);
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
          alldata.add(tempMap);
          tempMap = {};
        }
        // ignore: avoid_print
        print(alldata);
      }

      data.removeAt(0);
      showTable = true;
      setState(() {});
    }
    return data;
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
        // ignore: avoid_print
        print('Done!');
      });
    }
  }

  Future<String> downloadCsv() async {
    final storage = FirebaseStorage.instance;
    final Reference ref = storage.ref('template');
    ListResult allFiles = await ref.listAll();
    final url = allFiles.items[0].getDownloadURL();
    return url;
  }

  openPdf(var url) {
    if (kIsWeb) {
      html.window.open(url, '_blank');
      final encodedUrl = Uri.encodeFull(url);
      html.Url.revokeObjectUrl(encodedUrl);
    } else {
      const Text('Sorry it is not ready for mobile platform');
    }
  }
}
