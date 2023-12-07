// ignore: duplicate_ignore
// ignore: avoid_web_libraries_in_flutter


// ignore_for_file: file_names, avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../excel/uploadExcel.dart';

class AddMember extends StatefulWidget {
  static const String id = "/addMember";
  const AddMember({super.key});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _societyNameController = TextEditingController();
  List<String> searchedList = [];
  List<List<dynamic>> data = [];

  bool showTable = false;

  List<List<TextEditingController>> controllers = [];
  List<List<dynamic>> columnNames = [];
  @override
  Widget build(BuildContext context) => Scaffold(
      // appBar: AppBar(
      //   title: Text("Add Member"),
      //   backgroundColor: Color.fromARGB(255, 0, 119, 255),
      // ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
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
                        _societyNameController.text = suggestion.toString();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => societyDetails(
                        //         societyNames: suggestion.toString()),
                        //   ),
                        // );
                      },
                    ),
                  )),
                  const SizedBox(width: 30),
                  SizedBox(
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: ElevatedButton(
                        style: const ButtonStyle(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UpExcel()),
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
              const SizedBox(
                height: 15,
              ),
              showTable
                  ? Container(
                      padding: const EdgeInsets.all(2.0),
                      height: 450,
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

                                ));
                              }),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // 'societyName' = _societyNameController.text;
          }
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
}
