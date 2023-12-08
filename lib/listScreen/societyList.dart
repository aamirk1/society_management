// ignore: duplicate_ignore
// ignore_for_file: file_names
//ignore: avoid_web_libraries_in_flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:society_management/customWidgets/colors.dart';
import 'package:society_management/viewScreen/societyView.dart';

// ignore: camel_case_types
class societyList extends StatefulWidget {
  static const id = "/societyList";
  const societyList({super.key});

  @override
  State<societyList> createState() => _societyListState();
}

// ignore: camel_case_types
class _societyListState extends State<societyList> {
  final TextEditingController _societyNameController = TextEditingController();

  List<String> searchedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "All Society",
          style: TextStyle(color:AppBarColor),
        ),
        backgroundColor: AppBarBgColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              children: [
                IconButton(
                  icon:  Icon(
                    Icons.person,
                    color:AppBarColor,
                  ),
                  onPressed: () {
                    // signOut();
                  },
                ),
                Text(
                  'Hi, ${FirebaseAuth.instance.currentUser?.email}',
                  style:  TextStyle(color:AppBarColor),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('society').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
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
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 45,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: ElevatedButton(
                            style: const ButtonStyle(),
                            onPressed: () {
                              Navigator.pushNamed(context, '/addSociety');
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: societyNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          societyNames[index],
                          style: TextStyle(color: TextListColor),
                        ),
                        // subtitle: Text(data.docs[index]['city']),
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
