// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:society_management/customWidgets/colors.dart';
import 'package:society_management/listScreen/MemberList/ListOfMemberName.dart';
import 'package:society_management/listScreen/Society/societyDetails.dart';

class ListOfMemberBill extends StatefulWidget {
  final String societyName;

  static const id = "/ListOfMemberBill";
  const ListOfMemberBill({super.key, required this.societyName});

  @override
  State<ListOfMemberBill> createState() => _ListOfMemberBillState();
}

class _ListOfMemberBillState extends State<ListOfMemberBill> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController monthyears = TextEditingController();
  bool isLoding = false;
  List<dynamic> columnName = [];
  List<String> searchedList = [];
  List<List<dynamic>> data = [];
  // ignore: prefer_collection_literals
  Map<String, dynamic> mapExcelData = Map();
  List<dynamic> alldata = [];
  bool showTable = false;
  List<dynamic> newRow = [];
  List<String> dateList = [];
  String monthyear = DateFormat('MMMM yyyy').format(DateTime.now());
  String fetch = DateFormat('MMMM yyyy').format(DateTime.now());
  @override
  void initState() {
    fetchMap(widget.societyName, monthyear)
        .whenComplete(() => {showTable = true, setState(() {})});

    super.initState();
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
              "All Members Account of ${widget.societyName}",
              style: TextStyle(color: AppBarColor),
            ),
          ),
          backgroundColor: AppBarBgColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 150, right: 10.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                            style: const TextStyle(color: Colors.white),
                            controller: monthyears,
                            decoration: const InputDecoration(
                                labelText: 'Selcet Month',
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder())),
                        suggestionsCallback: (pattern) async {
                          return await getMonthReceipt(pattern);
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            textColor: Colors.black,
                            title: Text(suggestion.toString()),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          monthyears.text = suggestion.toString();
                          fetchMap(widget.societyName, monthyears.text);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => ListOfMemberBill(
                          //             societyName: suggestion.toString(),
                          //           )),
                          // );
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
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: showTable == false
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              Text('Collecting Data...')
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(2.0),
                          height: 450,
                          width: MediaQuery.of(context).size.width,
                          child: DataTable2(
                            minWidth: 2500,
                            border: TableBorder.all(color: Colors.black),
                            headingRowColor:
                                const MaterialStatePropertyAll(Colors.blue),
                            headingTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 50.0,
                            ),
                            columnSpacing: 3.0,
                            columns: List.generate(columnName.length, (index) {
                              return DataColumn2(
                                fixedWidth: index == 1 ? 500 : 130,
                                label: Text(
                                  columnName[index],
                                  style: const TextStyle(
                                      // overflow: TextOverflow.ellipsis,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }),
                            rows: List.generate(
                              growable: true,
                              data.length,
                              (index1) => DataRow2(
                                cells: List.generate(
                                    growable: true, data[0].length, (index2) {
                                  return data[index1][index2] != 'Status'
                                      ? DataCell(Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 2.0),
                                          // child: Text(data[index1][index2]),

                                          child: TextFormField(
                                              style:
                                                  const TextStyle(fontSize: 12),
                                              // controller: controllers[index1][index2],
                                              onChanged: (value) {
                                                data[index1][index2] = value;
                                              },
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 3.0,
                                                          right: 3.0),
                                                  // border:
                                                  //     const OutlineInputBorder(),
                                                  hintText: data[index1]
                                                      [index2],
                                                  hintStyle: const TextStyle(
                                                      fontSize: 11.0,
                                                      color: Colors.black))),
                                        ))
                                      : DataCell(ElevatedButton(
                                          style: const ButtonStyle(
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.blue)),
                                          onPressed: () {},
                                          child: const Text('Pay')));
                                }),
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: FloatingActionButton(
                        heroTag: 'add',
                        backgroundColor: Colors.blue,
                        onPressed: () {
                          newRow = List.filled(data[0].length - 1, '');
                          newRow.add('Status');
                          data.add(newRow);

                          setState(() {
                            // const ListTile(
                            //   title: Text('Pay'),
                            //   trailing: Icon(Icons.check),
                            // );
                          });
                        },
                        child: const Icon(Icons.add),
                      ),
                    ),
                    FloatingActionButton(
                      heroTag: 'save',
                      backgroundColor: Colors.blue,
                      onPressed: storeEditedData,
                      child: const Icon(Icons.check),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  getUserdata(String pattern) async {
    searchedList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('accounts').get();

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

  Future<void> storeEditedData() async {
    List<Map<String, dynamic>> mapdata = [];
    Map<String, dynamic> temp = {};
    // print("data - $data");
    for (int i = 0; i < data[0].length; i++) {
      temp[columnName[i]] = columnName[i];
    }
    mapdata.add(temp);

    for (List<dynamic> listData in data) {
      Map<String, dynamic> tempMap = {};
      for (int i = 0; i < listData.length; i++) {
        tempMap[columnName[i]] = listData[i];
      }
      mapdata.add(tempMap);
    }

    FirebaseFirestore.instance
        .collection('accounts')
        .doc(widget.societyName)
        .collection('month')
        .doc(monthyear)
        .update({"data": mapdata}).whenComplete(
      () => const ScaffoldMessenger(
        child: SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Data Saved Successfully',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  Future<void> fetchMap(String societyName, String monthyear) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(societyName)
        .collection('month')
        .doc(monthyear)
        .get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data1 = docSnapshot.data() as Map<String, dynamic>;
      List<dynamic> mapData = data1['data'];
      List<List<dynamic>> temp = [];
      for (int i = 0; i < mapData.length; i++) {
        temp.add([
          mapData[i]['Flat No.'] ?? '',
          mapData[i]['Member Name'] ?? '',
          mapData[i]['Opening Balance'] ?? '',
          mapData[i]['Maintenance Charges'] ?? '',
          mapData[i]['Sinking fund'] ?? '',
          mapData[i]['Repair Fund- External Repair Only'] ?? '',
          mapData[i]['Insurance'] ?? '',
          mapData[i]['Electricity Chg.'] ?? '',
          mapData[i]['Water Charges'] ?? '',
          mapData[i]['Parking Charges 2 Wheeler'] ?? '',
          mapData[i]['Non Occupancy Charges'] ?? '',
          mapData[i]['Parking Charges- 3&4  Wheeler'] ?? '',
          mapData[i]['Recovery of Property Tax- 3/4'] ?? '',
          'Status'
        ]);
      }
      columnName = temp[0];
      data = temp;
      data.removeAt(0);

      // Use the data map as needed
    }
  }

  getMonthReceipt(String pattern) async {
    dateList.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ladgerReceipt')
        .doc(widget.societyName)
        .collection('month')
        .get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        dateList.add(tempList[i]);
      } else {
        // dateList.add('Not Availabel');
      }
    }
    // print(searchedList.length);
    return dateList;
  }
}
