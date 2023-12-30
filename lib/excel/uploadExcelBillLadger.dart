// ignore: duplicate_ignore
// ignore_for_file: file_names
//ignore: avoid_web_libraries_in_flutter
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:society_management/customWidgets/colors.dart';

// import '../excel/uploadExcel.dart';

class UpExcelBillLadger extends StatefulWidget {
  static const String id = "/UpExcelBillLadger";
  const UpExcelBillLadger({super.key, required this.societyName});
  final String societyName;

  @override
  State<UpExcelBillLadger> createState() => _UpExcelBillLadgerState();
}

class _UpExcelBillLadgerState extends State<UpExcelBillLadger> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _societyNameController = TextEditingController();
  List<dynamic> columnName = [];
  List<String> searchedList = [];
  String url = '';
  List<List<dynamic>> data = [];
  // ignore: prefer_collection_literals
  Map<String, dynamic> mapExcelData = Map();
  List<dynamic> alldata = [];
  // String monthyear = 'February 2024';
  String monthyear = DateFormat('MMMM yyyy').format(DateTime.now());

  bool showTable = false;

  @override
  void initState() {
    // print(monthyear);
    super.initState();
    downloadCsv();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppBarColor),
        title: Text(
          "Upload Ledger ${widget.societyName}",
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
              showTable
                  ? Container(
                      padding: const EdgeInsets.all(2.0),
                      height: 398,
                      width: MediaQuery.of(context).size.width,
                      child: DataTable2(
                        minWidth: 1700,
                        // border: const TableBorder(
                        //     horizontalInside: BorderSide(
                        //   color: Colors.black,
                        // )),
                        border: TableBorder.all(color: Colors.black),
                        headingRowColor:
                            const MaterialStatePropertyAll(Colors.purple),
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
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(AppBarBgColor),  
                      ),
                      onPressed: selectExcelFile,
                      child: const Text(
                        "Upload Excel",
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(AppBarBgColor),
                      ),
                      onPressed: () {
                        openPdf(url);
                      },
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
        backgroundColor: AppBarBgColor,
        onPressed: () async {
          // for (int i = 0; i < mapExcelData.length; i++) {
          await FirebaseFirestore.instance
              .collection('ladgerBill')
              .doc(widget.societyName)
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
              .collection('ladgerBill')
              .doc(widget.societyName)
              .set({'name': widget.societyName});
          //       }
          // Perform desired action with the form data

          _societyNameController.clear();
          // ignore: use_build_context_synchronously
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
        // print(alldata);
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
          .collection('ladgerBill')
          .doc(widget.societyName)
          .collection('tableData')
          .doc('$i')
          .set({
        'societyName': widget.societyName,
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
    url = await allFiles.items[1].getDownloadURL();
    print('url - $url');
    return url.toString();
  }

  openPdf(String url) {
    if (kIsWeb) {
      html.window.open(url, '_blank');
      final encodedUrl = Uri.encodeFull(url);
      html.Url.revokeObjectUrl(encodedUrl);
    } else {
      const Text('Sorry it is not ready for mobile platform');
    }
  }
}
