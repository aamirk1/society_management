import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

class CustomDataTable extends StatefulWidget {
  const CustomDataTable({super.key});

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  final StreamController<List<List<dynamic>>> _data =
      StreamController<List<List<dynamic>>>();

  List<List<dynamic>> rows = [
    ['12', 'Suraj', '9867675713', 'Thane'],
    ['13', 'Aditya', '9867675713', 'Thane'],
    ['14', 'Gray', '9867675713', 'Thane'],
    ['16', 'Saroj', '9867675713', 'Thane'],
    ['72', 'Simran', '9867675713', 'Thane'],
    ['19', 'Daku', '9867675713', 'Thane']
  ];
  Stream<List<List<dynamic>>> get _streamData => _data.stream;

  List<dynamic> columns = ['Age', 'Name', 'Number', 'City'];

  @override
  void initState() {
    addData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<List<List<dynamic>>>(
                  stream: _streamData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      List<List<dynamic>>? data = snapshot.data;
                      return DataTable(
                        columns: columns
                            .map((cell) => DataColumn(label: Text(cell)))
                            .toList(),
                        rows: List.generate(
                          data!.length,
                          (index1) => DataRow(
                            cells: List.generate(
                              data[index1].length,
                              (index2) => DataCell(
                                TextFormField(
                                  initialValue: data[index1][index2],
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: data[index1][index2]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Container();
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        addRow();
      }),
    );
  }

  addData() {
    _data.add(rows);
  }

  addRow() {
    List<dynamic> _blankRow = ['', '', '', ''];
    rows.add(_blankRow);
    _data.add(rows);
  }
}
