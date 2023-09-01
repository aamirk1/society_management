import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_management/viewScreen/committeeView.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class committeeList extends StatefulWidget {
  static const id = "/committeeList";
  const committeeList({super.key});

  @override
  State<committeeList> createState() => _committeeListState();
}

class _committeeListState extends State<committeeList> {
  final TextEditingController _nameController = TextEditingController();

  List<String> searchedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('committee').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data;
              // String cityname = '';

              List<dynamic> committeeNames =
                  data!.docs.map((e) => e.id).toList();

              return Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: Container(
                        padding: const EdgeInsets.all(8),
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _nameController,
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontStyle: FontStyle.italic),
                              decoration: const InputDecoration(
                                  labelText: 'Search Committee Members',
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
                            _nameController.text = suggestion.toString();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => committeeDetails(
                                    name: suggestion.toString()),
                              ),
                            );
                          },
                        ),
                      )),
                      const SizedBox(width: 10),
                      Container(
                        height: 45,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: ElevatedButton(
                            style: ButtonStyle(),
                            onPressed: () {
                              Navigator.pushNamed(context, '/addCommittee');
                            },
                            child: const Icon(
                              Icons.add,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: committeeNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(committeeNames[index]),
                        subtitle: Text(data.docs[index]['designation']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  committeeDetails(name: committeeNames[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            } else {
              Text("Not Availabel");
            }
            return Container();
          },
        ),
      ),
    );
  }

  getUserdata(String pattern) async {
    searchedList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('committee').get();

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
}