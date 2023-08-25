import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:society_management/viewScreen/societyView.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class societyList extends StatefulWidget {
  static const id = "/societyList";
  societyList({super.key});

  @override
  State<societyList> createState() => _societyListState();
}

class _societyListState extends State<societyList> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _societyNameController = TextEditingController();

  List<String> searchedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('society').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data;
              // String cityname = '';

              List<dynamic> societyNames = data!.docs.map((e) => e.id).toList();

              return Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: Container(
                        padding: EdgeInsets.all(5),
                        child: TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              controller: _societyNameController,
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontStyle: FontStyle.italic),
                              decoration: InputDecoration(
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => societyDetails(
                                    societyNames: suggestion.toString()),
                              ),
                            );
                          },
                        ),
                      )),
                      SizedBox(width: 10),
                      Container(
                        height: 45,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: ElevatedButton(
                            style: ButtonStyle(),
                            onPressed: () {
                              Navigator.pushNamed(context, '/addSociety');
                            },
                            child: Icon(
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
                    itemCount: societyNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(societyNames[index]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => societyDetails(
                                  societyNames: societyNames[index]),
                            ),
                          );
                        },
                      );
                    },
                  )
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
        await FirebaseFirestore.instance.collection('society').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();
    print(tempList);

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].toLowerCase().contains(pattern.toLowerCase())) {
        searchedList.add(tempList[i]);
      }
    }
    print(searchedList.length);
    return searchedList;
  }
}
