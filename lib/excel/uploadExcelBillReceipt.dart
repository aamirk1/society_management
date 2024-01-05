// ignore: duplicate_ignore
// ignore_for_file: file_names
//ignore: avoid_web_libraries_in_flutter
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
import 'package:provider/provider.dart';
import 'package:society_management/customWidgets/colors.dart';
import 'package:society_management/listScreen/MemberList/ListOfMemberName.dart';
import 'package:society_management/listScreen/Society/customSocietysidebar.dart';
import 'package:society_management/listScreen/Society/societyDetails.dart';
import 'package:society_management/provider/upload_receipt_provider.dart';

// import '../excel/uploadExcel.dart';

class UpExcelBillReceipt extends StatefulWidget {
  static const String id = "/UpExcelBillReceipt";
  UpExcelBillReceipt({super.key, required this.societyName});
  final String societyName;

  @override
  State<UpExcelBillReceipt> createState() => _UpExcelBillReceiptState();
}

class _UpExcelBillReceiptState extends State<UpExcelBillReceipt> {
  TextEditingController _societyNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<dynamic> columnName = [];
  List<String> searchedList = [];
  List<List<dynamic>> data = [];
  String url = '';
  // ignore: prefer_collection_literals
  Map<String, dynamic> mapExcelData = Map();
  List<List<dynamic>> alldata = [];
  List<Map<String, dynamic>> newData = [];

  List<String> monthList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  String monthyear = DateFormat('yyyy').format(DateTime.now());
  String monthAndYear = '';
  bool showTable = false;
  List<bool> buttonBoolList = [];

  @override
  void initState() {
    super.initState();
    setMonthlyBoolean();
    downloadCsv();
  }

  @override
  Widget build(BuildContext context) {
    final selectedMonth =
        Provider.of<UploadReceiptProvider>(context, listen: false)
            .selectedMonth;
    final provider = Provider.of<UploadReceiptProvider>(context);
    return Scaffold(
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
              "Upload Receipt of ${widget.societyName}",
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: ListView.builder(
                      itemCount: monthList.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(left: 8.0, top: 5),
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    buttonBoolList[index] == true
                                        ? const Color.fromARGB(255, 91, 16, 104)
                                        : Colors.purple)),
                            onPressed: () {
                              setButtonBoolean(index);
                              provider.setMonth(monthList[index]);
                              provider.reload(true);
                            },
                            child: Text(monthList[index]),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                showTable
                    // ? SingleChildScrollView(
                    //     scrollDirection: Axis.vertical,
                    //     child: Container(
                    //       width: 1000,
                    //       height: MediaQuery.of(context).size.height - 50,
                    //       child: ListView.builder(
                    //           itemCount: alldata.length,
                    //           itemBuilder: (context, index) {
                    //             return Padding(
                    //               padding: const EdgeInsets.all(8.0),
                    //               child: Text(alldata[index]),
                    //             );
                    //           }),
                    //     ),
                    //   )
                    ? columnName.isEmpty
                        ? alertBox()
                        : Container(
                            padding: const EdgeInsets.all(2.0),
                            height: 398,
                            width: MediaQuery.of(context).size.width,
                            child: DataTable2(
                              minWidth: 1700,
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
                                alldata.length,
                                (index1) => DataRow2(
                                  cells: List.generate(
                                      growable: true,
                                      alldata[0].length, (index2) {
                                    return DataCell(Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 5.0),
                                      child: Text(
                                          alldata[index1][index2].toString()),
                                    ));
                                  }),
                                ),
                              ),
                            ),
                          )
                    : Container(),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      // ListView.builder(
                      //     shrinkWrap: true,
                      //     scrollDirection: Axis.horizontal,
                      //     itemBuilder: (context, index) {
                      //       return ElevatedButton(
                      //           onPressed: () {}, child: Text(monthList[index]));
                      //     }),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(AppBarBgColor),
                        ),
                        onPressed: () async {
                          if (selectedMonth.trim().isNotEmpty) {
                            monthAndYear = "$selectedMonth $monthyear";
                            selectExcelFile();
                          } else {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.all(5),
                                    icon: const Icon(
                                      Icons.warning_amber,
                                      size: 60,
                                      color: Color.fromARGB(255, 212, 194, 25),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'))
                                    ],
                                    title: const Text(
                                      'Please Select A Month !',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                });
                          }
                        },
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
            String fetch = 'January $monthyear';
            // for (int i = 0; i < alldata.length; i++) {
            await FirebaseFirestore.instance
                .collection('ladgerReceipt')
                .doc(widget.societyName)
                .collection('month')
                .doc(monthAndYear)
                .set({
              'data': newData,
            });
            // }
            await FirebaseFirestore.instance
                .collection('ladgerReceipt')
                .doc(widget.societyName)
                .set({'name': widget.societyName});
            //       }

            Navigator.pop(context);
          },
          child: const Icon(Icons.check),
        ));
  }

  setMonthlyBoolean() {
    List<bool> boolList = [];
    for (int i = 0; i < monthList.length; i++) {
      boolList.add(false);
    }
    buttonBoolList = boolList;
  }

  setButtonBoolean(int exceptIndex) {
    List<bool> boolList = [];
    for (int i = 0; i < monthList.length; i++) {
      if (i == exceptIndex) {
        boolList.add(true);
      } else {
        boolList.add(false);
      }
    }
    buttonBoolList = boolList;
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
        // print('rowssdataa- $rowData');
        // newData.add(rowData);
        // data.addAll(newData.skip(1));
        // print('dataaaaaa - $data');
        // for (int i = 0; i < columnName.length; i++) {
        //   tempMap[columnName[i]] = rows[i].toString();
        // }
        alldata.add(rowData);

        newData.add(tempMap);
        // print('alldata - $alldata');
        tempMap = {};
      }

      alldata.removeAt(0);
      print('aaaa - $newData');

      // alldata.add(data);
      // print(alldata);
      // final file = files[0];
      // final reader = FileReader();

      // reader.readAsArrayBuffer(file);

      // await reader.onLoadEnd.first;

      // final excel = Excel.decodeBytes(reader.result as List<int>);

      // for (var table in excel.tables.keys) {
      //   final sheet = excel.tables[table];

      //   for (var rows in sheet!.rows.skip(0)) {
      //     Map<String, dynamic> tempMap = {};
      //     if (columnName.isEmpty) {
      //       for (var cells in sheet.rows[0]) {
      //         columnName.add(cells!.value.toString());
      //       }
      //     }

      //     List<dynamic> rowData = [];
      //     for (var cell in rows) {
      //       rowData.add(cell?.value.toString() ?? '');
      //     }

      //     data.add(rowData);

      //     for (int i = 0; i < columnName.length; i++) {
      //       tempMap[columnName[i]] = rowData[i];
      //     }
      //     alldata.add(tempMap);
      //     tempMap = {};
      //   }
      //   // print(alldata);
      // }

      data.removeAt(0);
      showTable = true;
      setState(() {});
    }
    return data;
  }

  alertBox() {
    return const AlertDialog(
      title: Center(
        child: Text(
          'No Data Found',
          style: TextStyle(fontSize: 20, color: Colors.red),
        ),
      ),
    );
  }

  getdat() async {
    for (int i = 0; i < data.length; i++) {
      FirebaseFirestore.instance
          .collection('ladgerReceipt')
          .doc(widget.societyName)
          .collection('tableData')
          .doc('$i')
          .set({
        'societyName': widget.societyName,
        '$i': alldata[i],
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
}
