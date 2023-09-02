import 'dart:html';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:society_management/provider/excel_provider.dart';

class UploadExcel extends StatefulWidget {
  const UploadExcel({super.key});

  @override
  State<UploadExcel> createState() => _UploadExcelState();
}

class _UploadExcelState extends State<UploadExcel> {
  List<List<dynamic>> data = [];

  bool showTable = false;

  List<List<TextEditingController>> controllers = [];
  List<List<dynamic>> columnNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showTable
          ? Container(
              padding: const EdgeInsets.all(2.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: DataTable(
                    columnSpacing: 5.0,
                    dataRowMinHeight: 10.0,
                    columns: columnNames[0]
                        .map((e) => DataColumn(
                              label: Text(
                                e,
                                style: const TextStyle(
                                    fontSize: 15.0,
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
                                  //         // border: const OutlineInputBorder(),
                                  //         hintText: data[index1][index2],
                                  //         hintStyle: const TextStyle(
                                  //             fontSize: 10.0,
                                  //             color: Colors.black))),
                                ));
                              }),
                            ))),
              ),
            )
          : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: selectExcelFile,
        child: const Icon(Icons.upload_file),
      ),
    );
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

        for (var rows in sheet!.rows) {
          List<dynamic> rowData = [];
          for (var cell in rows) {
            rowData.add(cell?.value);
          }
          data.add(rowData);
        }
      }
      data = convertSubstringsToStrings(data);
      columnNames.add(data[0]);
      // print(columnNames);
      data.removeAt(0);
      // generateTextEditingController(data);
      showTable = true;
      setState(() {});
    }
    return data;
  }

  List<List<dynamic>> convertSubstringsToStrings(
      List<List<dynamic>> listOfLists) {
    List<List<dynamic>> result = [];

    for (List<dynamic> sublist in listOfLists) {
      List<dynamic> convertedSublist =
          sublist.map((item) => item.toString()).toList();
      result.add(convertedSublist);
    }
    // print(result);
    return result;
  }

  // void generateTextEditingController(List<List<dynamic>> selectedExcel) {
  //   controllers = List.generate(selectedExcel.length, (index) {
  //     return List.generate(data[0].length, (index) => TextEditingController());
  //   });
  //   print(controllers.length);
  //   print(controllers[0].length);
  // }
}
