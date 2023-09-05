import 'dart:html';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
  List<String> searchedList = [];
  List<Map<String, dynamic>> data = [];

  bool showTable = false;

  List<List<TextEditingController>> controllers = [];
  List<List<dynamic>> columnNames = [];
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("Upload Members"),
        backgroundColor: const Color.fromARGB(255, 0, 119, 255),
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
                      },
                    ),
                  )),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              showTable
                  ? Container(
                      padding: const EdgeInsets.all(2.0),
                      height: 398,
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 5.0,
                          dataRowMinHeight: 10.0,
                          columns: columnNames[0]
                              .map((e) => DataColumn(
                                    label: Text(
                                      e,
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
          // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          //     .collection('members')
          //     .doc('Chhatrapati Shivaji Maharaj Vastu Sangrahalaya')
          //     .collection('tableData')
          //     .get();
          // List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();

          // for (int i = 0; i < tempList.length; i++) {
          //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          //       .collection('members')
          //       .doc('Chhatrapati Shivaji Maharaj Vastu Sangrahalaya')
          //       .collection('tableData')
          //       .doc('$i')
          //       .get();

          //   Map<String, dynamic> data =
          //       documentSnapshot.data() as Map<String, dynamic>;

          //   print(data);
          // }

          for (int i = 0; i < data.length; i++) {
            FirebaseFirestore.instance
                .collection('members')
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

          FirebaseFirestore.instance
              .collection('members')
              .doc(_societyNameController.text)
              .set({'societyName': _societyNameController.text});
          // Perform desired action with the form data

          _societyNameController.clear();
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

  Future<List<Map<String, dynamic>>> selectExcelFile() async {
    List<Map<String, dynamic>> rowcolumncells = [];
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
        List<dynamic> header = [];

        if (header.isEmpty) {
          for (var cells in sheet!.rows[0]) {
            header.add(cells!.value);
          }
        }
        // print('Header: $header');
        for (var rows in sheet!.rows.skip(0)) {
          List<dynamic> rowData = [];
          for (var cell in rows) {
            rowData.add(cell?.value);
          }

          for (int i = 0; i < rowData.length; i++) {
            rowcolumncells.add({header[i]: rowData[i]});
          }

          print(rowcolumncells);

          // data.add(rowData);
        }
        data = rowcolumncells;
      }
      data = convertSubstringsToStrings(data);
      // columnNames.add(data[0]);
      // print(columnNames);
      data.removeAt(0);
      // generateTextEditingController(data);
      showTable = true;
      setState(() {});
    }
    // print(data);
    return data;
  }

  List<Map<String, dynamic>> convertSubstringsToStrings(
      List<Map<String, dynamic>> listOfLists) {
    List<Map<String, dynamic>> result = [];

    for (Map<String, dynamic> sublist in listOfLists) {
      Map<String, dynamic> convertedSublist =
          sublist.map((key, value) => MapEntry(key, value.toString()));
      result.add(convertedSublist);
    }
    // print(result);
    return result;
  }

  getdat() async {
    for (int i = 0; i < data.length; i++) {
      FirebaseFirestore.instance
          .collection('members')
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
}

// import 'dart:html';

// import 'package:excel/excel.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:society_management/provider/excel_provider.dart';

// class UploadExcel extends StatefulWidget {
//   const UploadExcel({super.key});

//   @override
//   State<UploadExcel> createState() => _UploadExcelState();
// }

// class _UploadExcelState extends State<UploadExcel> {
//   List<List<dynamic>> data = [];

//   bool showTable = false;

//   List<List<TextEditingController>> controllers = [];
//   List<List<dynamic>> columnNames = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: showTable
//           ? Container(
//               padding: const EdgeInsets.all(2.0),
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: SingleChildScrollView(
//                 child: DataTable(
//                   columnSpacing: 5.0,
//                   dataRowMinHeight: 10.0,
//                   columns: columnNames[0]
//                       .map((e) => DataColumn(
//                             label: Text(
//                               e,
//                               style: const TextStyle(
//                                   fontSize: 15.0, fontWeight: FontWeight.bold),
//                             ),
//                           ))
//                       .toList(),
//                   rows: List.generate(
//                     growable: true,
//                     data.length,
//                     (index1) => DataRow(
//                       cells: List.generate(growable: true, data[0].length,
//                           (index2) {
//                         return DataCell(Padding(
//                           padding: const EdgeInsets.only(bottom: 5.0),
//                           child: Text(data[index1][index2]),
//                           // child: TextFormField(
//                           //     // controller: controllers[index1][index2],
//                           //     onChanged: (value) {
//                           //       data[index1][index2] = value;
//                           //     },
//                           //     decoration: InputDecoration(
//                           //         contentPadding: const EdgeInsets.only(
//                           //             left: 3.0, right: 3.0),
//                           //         // border: const OutlineInputBorder(),
//                           //         hintText: data[index1][index2],
//                           //         hintStyle: const TextStyle(
//                           //             fontSize: 10.0,
//                           //             color: Colors.black))),
//                         ));
//                       }),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           : Container(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: selectExcelFile,
//         child: const Icon(Icons.upload_file),
//       ),
//     );
//   }

//   Future<List<List<dynamic>>> selectExcelFile() async {
//     final input = FileUploadInputElement()..accept = '.xlsx';
//     input.click();

//     await input.onChange.first;
//     final files = input.files;

//     if (files?.length == 1) {
//       final file = files?[0];
//       final reader = FileReader();

//       reader.readAsArrayBuffer(file!);

//       await reader.onLoadEnd.first;

//       final excel = Excel.decodeBytes(reader.result as List<int>);
//       for (var table in excel.tables.keys) {
//         final sheet = excel.tables[table];

//         for (var rows in sheet!.rows) {
//           List<dynamic> rowData = [];
//           for (var cell in rows) {
//             rowData.add(cell?.value);
//           }
//           data.add(rowData);
//         }
//       }
//       data = convertSubstringsToStrings(data);
//       columnNames.add(data[0]);
//       // print(columnNames);
//       data.removeAt(0);
//       // generateTextEditingController(data);
//       showTable = true;
//       setState(() {});
//     }
//     return data;
//   }

//   List<List<dynamic>> convertSubstringsToStrings(
//       List<List<dynamic>> listOfLists) {
//     List<List<dynamic>> result = [];

//     for (List<dynamic> sublist in listOfLists) {
//       List<dynamic> convertedSublist =
//           sublist.map((item) => item.toString()).toList();
//       result.add(convertedSublist);
//     }
//     // print(result);
//     return result;
//   }

//   // void generateTextEditingController(List<List<dynamic>> selectedExcel) {
//   //   controllers = List.generate(selectedExcel.length, (index) {
//   //     return List.generate(data[0].length, (index) => TextEditingController());
//   //   });
//   //   print(controllers.length);
//   //   print(controllers[0].length);
//   // }
// }
