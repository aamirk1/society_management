// ignore: duplicate_ignore
// ignore_for_file: file_names
//ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:society_management/customWidgets/colors.dart';
import 'package:society_management/customWidgets/custom_textfield.dart';
import 'package:society_management/listScreen/Society/customSocietysidebar.dart';

// import '../excel/uploadExcel.dart';

class UpExcel extends StatefulWidget {
  static const String id = "/UpExcel";
  const UpExcel({super.key, required this.societyName});
  final String societyName;

  @override
  State<UpExcel> createState() => _UpExcelState();
}

class _UpExcelState extends State<UpExcel> {
  String url = '';
  TextEditingController _societyNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<dynamic> columnName = [];
  List<String> searchedList = [];
  List<List<dynamic>> data = [];
  // ignore: prefer_collection_literals
  Map<String, dynamic> mapExcelData = Map();
  List<dynamic> alldata = [];
  Map<String, dynamic> fieldMap = {};
  List<dynamic> fielddata = [];

  List<Map<String, dynamic>> newData = [];
  bool showTable = false;

  @override
  void initState() {
    super.initState();
    downloadCsv();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Add Member in ${widget.societyName}",
          style: TextStyle(color: AppBarColor),
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
                const SizedBox(
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
                  ? Expanded(
                      child: Container(
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
                              cells: List.generate(
                                  growable: true, data[0].length, (index2) {
                                return DataCell(Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text(data[index1][index2].toString()),
                                ));
                              }),
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
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(AppBarBgColor),
                        ),
                        onPressed: selectExcelFile,
                        child: const Text(
                          "Upload Excel",
                        )),
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
                        )),
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
          FirebaseFirestore.instance
              .collection('members')
              .doc(widget.societyName)
              .set({
            'data': newData,
          }).then((value) {
            const ScaffoldMessenger(
                child: SnackBar(
              content: Text('Successfully Uploaded'),
            ));
          });
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

  // ignore: non_constant_identifier_names
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
              style: const TextStyle(color: Colors.black),
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

  Future<String> downloadCsv() async {
    final storage = FirebaseStorage.instance;
    final Reference ref = storage.ref('template');
    ListResult allFiles = await ref.listAll();
    url = await allFiles.items[0].getDownloadURL();
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

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }
}
