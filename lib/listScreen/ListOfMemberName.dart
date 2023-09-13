import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class societyPage extends StatefulWidget {
  String societyName;
  static const id = "/societyPage";
  societyPage({super.key, required this.societyName});

  @override
  State<societyPage> createState() => _societyPageState();
}

class _societyPageState extends State<societyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _societyNameController = TextEditingController();
  List<dynamic> columnName = [];
  List<String> searchedList = [];
  List<List<dynamic>> data = [];
  Map<String, dynamic> mapExcelData = Map();
  List<dynamic> alldata = [];
  bool showTable = false;

  @override
  void initState() {
    fetchMap(widget.societyName);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("All Members"),
          backgroundColor: const Color.fromARGB(255, 0, 119, 255),
        ),
        body: Padding(
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
                    height: 500,
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: SingleChildScrollView(
                      child: DataTable(
                        // border: const TableBorder(
                        //     horizontalInside: BorderSide(
                        //   color: Colors.black,
                        // )),
                        headingRowColor: MaterialStatePropertyAll(Colors.blue),
                        headingTextStyle: const TextStyle(
                            color: Colors.white, fontSize: 50.0),
                        columnSpacing: 5.0,
                        dataRowMinHeight: 10.0,
                        columns: columnName
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
                            cells: List.generate(growable: true, data[0].length,
                                (index2) {
                              print('Data - ${data[index1][index2]}');
                              return data[index1][index2] != 'Status'
                                  ? DataCell(Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 2.0),
                                      // child: Text(data[index1][index2]),

                                      child: TextFormField(
                                          style: const TextStyle(fontSize: 22),
                                          // controller: controllers[index1][index2],
                                          onChanged: (value) {
                                            data[index1][index2] = value;
                                          },
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 3.0, right: 3.0),
                                              border:
                                                  const OutlineInputBorder(),
                                              hintText: data[index1][index2],
                                              hintStyle: const TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.black))),
                                    ))
                                  : DataCell(ElevatedButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.red)),
                                      onPressed: () {},
                                      child: const Text('Deactivate')));
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // for (int i = 0; i < mapExcelData.length; i++) {
            await FirebaseFirestore.instance
                .collection('members')
                .doc(widget.societyName)
                .update({
              'data': alldata,
            }).then((value) {
              const ScaffoldMessenger(
                  child: SnackBar(
                content: Text('Successfully Updated'),
                backgroundColor: Colors.green,
              ));
            });
            //       }
            // Perform desired action with the form data

            // _societyNameController.clear();
          },
          child: const Icon(Icons.check),
        ),
      );

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

  void fetchMap(String societyName) async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('members')
        .doc(societyName)
        .get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data1 = docSnapshot.data() as Map<String, dynamic>;
      List<dynamic> mapData = data1['data'];
      List<List<dynamic>> temp = [];
      for (int i = 0; i < mapData.length; i++) {
        temp.add([
          mapData[i]['Item'],
          mapData[i]['OrderDate'],
          mapData[i]['Region'],
          mapData[i]['Rep'],
          mapData[i]['Total'],
          mapData[i]['Unit Cost'],
          mapData[i]['Units'],
          'Status'
        ]);
      }
      columnName = temp[0];
      data = temp;
      data.removeAt(0);
      showTable = true;
      setState(() {});
      print('Temp - ${temp}');

      // Use the data map as needed
    }
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
