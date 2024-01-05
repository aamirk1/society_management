// ignore: duplicate_ignore
// ignore_for_file: file_names
//ignore: avoid_web_libraries_in_flutter
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:society_management/customWidgets/colors.dart';
import 'package:society_management/listScreen/MemberList/ListOfMemberName.dart';
import 'package:society_management/listScreen/Society/customSocietysidebar.dart';
import 'package:society_management/listScreen/Society/societyDetails.dart';

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

  List<Map<String, dynamic>> newData = [];
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
        title: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return societyDetails(
                societyNames: widget.societyName,
              );
            }));
          },
          child: Text(
            "Upload Bill of ${widget.societyName}",
            style: TextStyle(color: AppBarColor),
          ),
        ),
        backgroundColor: AppBarBgColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            controller: _societyNameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                labelText: 'Search Society',
                                labelStyle: TextStyle(color: Colors.white),
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
                              builder: (context) => customSocietySide(
                                  societyNames: suggestion.toString()),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                const  SizedBox(
                    width: 10,
                  ),
                IconButton(
                  icon: Icon(
                    Icons.logout_rounded,
                    color: AppBarColor,
                  ),
                  onPressed: () {
                    signOut(context);
                  },
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
                                child: Text(data[index1][index2].toString()),
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
                        backgroundColor:
                            MaterialStatePropertyAll(AppBarBgColor),
                      ),
                      onPressed: selectExcelFile,
                      child: const Text(
                        "Upload Excel",
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(AppBarBgColor),
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
            'data': newData,
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
    final input = FileUploadInputElement()..accept = '.csv';
    input.click();

    await input.onChange.first;
    final files = input.files;
    print('filesssssss- ${files!.first.name}');
    if (files.length == 1) {
      // final myData = await rootBundle.loadString('${files.first.name}');
      final reader = FileReader();
      reader.readAsText(files[0]);
      await reader.onLoad.first;
      final myData = reader.result as String;

      List<List<dynamic>> csvTable = const CsvToListConverter().convert(myData);
      print(csvTable);
      data = csvTable;
      print('dataaaaaa- $data');
      //   final sheet = excel.tables[table];
      // if (columnName.isEmpty) {
      //   for (var cells in data[0]) {
      //     columnName.add(cells!.toString());
      //   }
      // }

      for (var a in data[0]) {
        columnName.add(a.toString().trim());
      }
      for (var rows in data) {
        Map<String, dynamic> tempMap = {};

        print('columnname - $columnName');

        List<dynamic> rowData = [];
        for (var cell in rows) {
          rowData.add(cell?.toString() ?? '');
        }

        for (int i = 0; i < columnName.length; i++) {
          tempMap[columnName[i]] = rowData[i];
        }
        alldata.add(rowData);

        newData.add(tempMap);
        // print('alldata - $alldata');
        tempMap = {};
      }

      alldata.removeAt(0);
      print('aaaa - $newData');

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
