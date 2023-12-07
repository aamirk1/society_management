import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:society_management/provider/filteration_provider.dart';
import 'package:society_management/provider/menuUserPageProvider.dart';
import 'package:society_management/viewScreen/committeeView.dart';

import 'menu_screen/assigned_user.dart';
import 'menu_screen/totalUser.dart';
import 'menu_screen/unAssignedUserPage.dart';

class MenuUserPage extends StatefulWidget {
  static const String id = 'user-page';
  const MenuUserPage({super.key});

  @override
  State<MenuUserPage> createState() => _MenuUserPageState();
}

class _MenuUserPageState extends State<MenuUserPage> {
  final TextEditingController _controllerSociety = TextEditingController();
  final TextEditingController _controllerForUser = TextEditingController();
  String selectedUserId = '';
  List<String> searchedList = [];

  // Boolean value fro updating and setting user role in database
  bool userExist = false;
  List<dynamic> societyList = [];
  List<dynamic> memberList = [];
  List<String> assignedUserList = [];
  int assignedUsers = 0;
  int totalUsers = 0;
  List<dynamic> unAssignedUserList = [];
  int unAssignedUser = 0;
  String selectedUserName = '';
  String selectedSocietyName = '';
  List<bool> changeColorForDepo = [];
  List<dynamic> selectedDepo = [];
  List<dynamic> selecteddesignation = [];
  List<dynamic> selectedCity = [];
  List<dynamic> role = [];
  List<bool> changeColorForRole = [];
  List<bool> changeColorForCity = [];
  List<bool> isRemoveDepo = [];
  List<String> cityData = [];
  Stream? _stream;
  bool showError = false;
  String errorMessage = '';
  bool isLoading = true;
  bool getDepooData = false;
  TextEditingController unAssignedUserController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  List<String> designation = ['Admin', 'Secretary', 'Treasurer'];

  List<String> cardTitle = [
    'Total User',
    'Assigned User',
    'Unassigned User',
  ];

  List<Color> cardColor = [
    const Color.fromARGB(255, 57, 177, 63),
    const Color.fromARGB(255, 76, 123, 250),
    const Color.fromARGB(255, 207, 45, 24),
  ];

  List<dynamic> depodata = [];
  bool isProjectManager = false;

  TextEditingController myController = TextEditingController();

  @override
  void initState() {
    getCityName().whenComplete(() => {
          isLoading = false,
          getCityLen(),
          if (mounted) {setState(() {})}
        });
    getDesigationLen();
    getTotalUsers().whenComplete(() => {
          isLoading = false,
          if (mounted) {setState(() {})}
        });

    _stream = FirebaseFirestore.instance
        .collection('User')
        .orderBy('FirstName')
        .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MenuUserPageProvider>(context, listen: true);
    return Scaffold(
      body: isLoading
          ? const CircularProgressIndicator()
          : Container(
              padding: const EdgeInsets.all(5.0),
              width: MediaQuery.of(context).size.width * 0.98,
              height: MediaQuery.of(context).size.height * 0.98,
              child: Column(
                children: [
                  Consumer<MenuUserPageProvider>(
                    builder: (context, providerValue, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          UserCard(context, totalUsers, cardTitle[0],
                              cardColor[0], const TotalUsers()),
                          UserCard(context, assignedUsers, cardTitle[1],
                              cardColor[1], const AssignedUser()),
                          UserCard(context, unAssignedUser, cardTitle[2],
                              cardColor[2], const UnAssingedUsers()),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                              ),
                              padding: const EdgeInsets.only(left: 10.0),
                              child: getDepooData
                                  ? const CircularProgressIndicator()
                                  : Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: TextButton(
                                                  style: const ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors.grey)),
                                                  onPressed: () {},
                                                  child: const Text(
                                                    ' Select Society:',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SingleChildScrollView(
                                                child: Container(
                                                  color: Colors.white,
                                                  height: 30,
                                                  width: 250,
                                                  child: TypeAheadField(
                                                    hideOnLoading: true,
                                                    textFieldConfiguration:
                                                        TextFieldConfiguration(
                                                      style: const TextStyle(
                                                          fontSize: 10),
                                                      controller:
                                                          _controllerSociety,
                                                      decoration: const InputDecoration(
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                          labelText:
                                                              'Select Society',
                                                          labelStyle: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color:
                                                                  Colors.black),
                                                          border:
                                                              OutlineInputBorder()),
                                                    ),
                                                    itemBuilder:
                                                        (context, suggestion) {
                                                      return ListTile(
                                                          title: Text(suggestion
                                                              .toString()));
                                                    },
                                                    onSuggestionSelected:
                                                        (suggestion) {
                                                      _controllerSociety.text =
                                                          suggestion.toString();
                                                      selectedSocietyName =
                                                          suggestion.toString();
                                                    },
                                                    suggestionsCallback:
                                                        (String pattern) async {
                                                      return await getUserdata(
                                                          pattern);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 100,
                                              ),
                                              TextButton(
                                                style: const ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.grey)),
                                                onPressed: () {},
                                                child: const Text(
                                                  'Select Member: ',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Consumer<MenuUserPageProvider>(
                                                builder: (context,
                                                    providerValue, child) {
                                                  return Container(
                                                    color: Colors.white,
                                                    height: 30,
                                                    width: 260,
                                                    child: TypeAheadField(
                                                      hideOnLoading: true,
                                                      textFieldConfiguration:
                                                          TextFieldConfiguration(
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                        controller:
                                                            _controllerForUser,
                                                        decoration: const InputDecoration(
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                            labelText:
                                                                'Select Member',
                                                            labelStyle: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .normal,
                                                                color: Colors
                                                                    .black),
                                                            border:
                                                                OutlineInputBorder()),
                                                      ),
                                                      itemBuilder: (context,
                                                          suggestion) {
                                                        return ListTile(
                                                          title: Text(
                                                            suggestion
                                                                .toString(),
                                                          ),
                                                        );
                                                      },
                                                      onSuggestionSelected:
                                                          (suggestion) async {
                                                        _controllerForUser
                                                                .text =
                                                            suggestion
                                                                .toString();

                                                        await getDataId(
                                                                suggestion
                                                                    .toString())
                                                            .whenComplete(
                                                                () {});

                                                        selectedUserName =
                                                            suggestion
                                                                .toString();
                                                        checkUserAlreadyExist(
                                                                selectedUserName)
                                                            .then((value) {
                                                          providerValue
                                                              .setLoadWidget(
                                                                  true);
                                                        });
                                                      },
                                                      suggestionsCallback:
                                                          (String
                                                              pattern) async {
                                                        return await getMemberList(
                                                            pattern);
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                              const SizedBox(
                                                width: 65,
                                              ),
                                              SizedBox(
                                                height: 30,
                                                width: 130,
                                                child: ElevatedButton(
                                                    style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.green)),
                                                    onPressed: () async {
                                                      for (int i = 0;
                                                          i < assignedUsers;
                                                          i++) {
                                                        if (assignedUserList[
                                                                i] ==
                                                            selectedUserName) {
                                                          // isDefined = true;
                                                        }
                                                      }

                                                      if (selectedUserName !=
                                                          selectedSocietyName) {
                                                        // if (isDefined ==
                                                        //     false) {
                                                        role.isEmpty
                                                            ? customAlertBox(
                                                                'Please Select Designation')
                                                            : selectedSocietyName
                                                                    .isEmpty
                                                                ? customAlertBox(
                                                                    'Please Select Society')
                                                                : storeAssignData();
                                                        getTotalUsers()
                                                            .whenComplete(
                                                                () async {
                                                          DocumentReference
                                                              documentReference =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'unAssignedRole')
                                                                  .doc(
                                                                      selectedUserName);

                                                          await documentReference
                                                              .delete();

                                                          provider
                                                              .setLoadWidget(
                                                                  true);
                                                        });
                                                        // } else {
                                                        //   customAlertBox(
                                                        //       '$selectedUserName is Already Assigned a Role');
                                                        // }
                                                      } else if (selectedUserName
                                                              .isEmpty &&
                                                          selectedSocietyName
                                                              .isEmpty) {
                                                        customAlertBox(
                                                            'Please Select Member and User');
                                                      } else {
                                                        customAlertBox(
                                                            'Reporting Manager and User cannot be same');
                                                      }
                                                    },
                                                    child: const Text(
                                                        'Assign Role')),
                                              )
                                            ],
                                          ),
                                        ),
                                        Consumer<MenuUserPageProvider>(
                                          builder: (context, value, child) {
                                            return Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 500),
                                                  child: showError
                                                      ? Text(
                                                          errorMessage,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                        )
                                                      : const Text(''),
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              top: 10.0,
                                              bottom: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0),
                                                child: SizedBox(
                                                  width: 130,
                                                  child: TextButton(
                                                    style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.grey)),
                                                    onPressed: () {},
                                                    child: const Text(
                                                      'Designation :',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Consumer<MenuUserPageProvider>(
                                                builder: (BuildContext context,
                                                    providerValue,
                                                    Widget? child) {
                                                  return SizedBox(
                                                    height: 30,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: GridView.builder(
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            designation.length,
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    6,
                                                                crossAxisSpacing:
                                                                    10.0,
                                                                mainAxisSpacing:
                                                                    5.0,
                                                                mainAxisExtent:
                                                                    30,
                                                                childAspectRatio:
                                                                    9.0),
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ElevatedButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStatePropertyAll(changeColorForRole[
                                                                            index]
                                                                        ? Colors
                                                                            .white
                                                                        : const Color.fromARGB(
                                                                            255,
                                                                            150,
                                                                            149,
                                                                            151))),
                                                            onPressed: () {
                                                              if (designation[
                                                                      index] ==
                                                                  'Others') {
                                                              } else {
                                                                if (designation[
                                                                        index] ==
                                                                    'Project Manager') {
                                                                  isProjectManager =
                                                                      true;
                                                                } else {
                                                                  isProjectManager =
                                                                      false;
                                                                }

                                                                changeColorForRole[
                                                                        index] =
                                                                    !changeColorForRole[
                                                                        index];
                                                                insertSelectedRole(
                                                                    index);
                                                                providerValue
                                                                    .setLoadWidget(
                                                                        true);
                                                              }
                                                            },
                                                            child: Text(
                                                              designation[
                                                                  index],
                                                              style: TextStyle(
                                                                  color: changeColorForRole[
                                                                          index]
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white,
                                                                  fontSize: 9),
                                                            ),
                                                          );
                                                        }),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        SingleChildScrollView(
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('committee')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (snapshot.hasData) {
                                                final data = snapshot.data;
                                                // String cityname = '';

                                                List<dynamic> committeeNames =
                                                    data!.docs
                                                        .map((e) => e.id)
                                                        .toList();

                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                            child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: TypeAheadField(
                                                            textFieldConfiguration: TextFieldConfiguration(
                                                                controller:
                                                                    _nameController,
                                                                style: DefaultTextStyle.of(
                                                                        context)
                                                                    .style
                                                                    .copyWith(
                                                                        fontStyle:
                                                                            FontStyle
                                                                                .italic),
                                                                decoration: const InputDecoration(
                                                                    labelText:
                                                                        'Search Committee Members',
                                                                    border:
                                                                        OutlineInputBorder())),
                                                            suggestionsCallback:
                                                                (pattern) async {
                                                              return await getUserdata(
                                                                  pattern);
                                                            },
                                                            itemBuilder:
                                                                (context,
                                                                    suggestion) {
                                                              return ListTile(
                                                                title: Text(
                                                                    suggestion
                                                                        .toString()),
                                                              );
                                                            },
                                                            onSuggestionSelected:
                                                                (suggestion) {
                                                              _nameController
                                                                      .text =
                                                                  suggestion
                                                                      .toString();
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      committeeDetails(
                                                                          name:
                                                                              suggestion.toString()),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )),
                                                        const SizedBox(
                                                            width: 10),
                                                        SizedBox(
                                                          height: 45,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 5.0),
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  const ButtonStyle(),
                                                              onPressed: () {
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    '/addCommittee');
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
                                                      height: 10,
                                                    ),
                                                    SizedBox(
                                                      height: 200,
                                                      child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            committeeNames
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ListTile(
                                                            title: Text(
                                                                committeeNames[
                                                                    index]),
                                                            subtitle: Text(data
                                                                    .docs[index]
                                                                [
                                                                'designation']),
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      committeeDetails(
                                                                          name:
                                                                              committeeNames[index]),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                const Text("Not Availabel");
                                              }
                                              return Container();
                                            },
                                          ),
                                        ),

                                        // Container(
                                        //   padding: const EdgeInsets.only(
                                        //       left: 10.0,
                                        //       top: 10.0,
                                        //       bottom: 10),
                                        //   child: Row(
                                        //     children: [
                                        //       Container(
                                        //         padding: const EdgeInsets.only(
                                        //             right: 10.0),
                                        //         child: SizedBox(
                                        //           width: 130,
                                        //           child: TextButton(
                                        //             style: ButtonStyle(
                                        //                 backgroundColor:
                                        //                     MaterialStatePropertyAll(
                                        //                         Colors.grey)),
                                        //             onPressed: () {},
                                        //             child: const Text(
                                        //               'Cities :',
                                        //               style: TextStyle(
                                        //                   fontSize: 10,
                                        //                   fontWeight:
                                        //                       FontWeight.bold,
                                        //                   color: Colors.white),
                                        //             ),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       Consumer<MenuUserPageProvider>(
                                        //         builder: (BuildContext context,
                                        //             providerValue,
                                        //             Widget? child) {
                                        //           return SizedBox(
                                        //             height: 30,
                                        //             width:
                                        //                 MediaQuery.of(context)
                                        //                         .size
                                        //                         .width *
                                        //                     0.65,
                                        //             child: ListView.builder(
                                        //               scrollDirection:
                                        //                   Axis.horizontal,
                                        //               shrinkWrap: true,
                                        //               itemCount:
                                        //                   cityData.length,
                                        //               itemBuilder:
                                        //                   (context, index) {
                                        //                 return Container(
                                        //                   padding:
                                        //                       const EdgeInsets
                                        //                               .only(
                                        //                           right: 10),
                                        //                   child: ElevatedButton(
                                        //                     style: ButtonStyle(
                                        //                         shadowColor:
                                        //                             const MaterialStatePropertyAll(
                                        //                                 Colors
                                        //                                     .black),
                                        //                         backgroundColor:
                                        //                             MaterialStatePropertyAll(changeColorForCity[
                                        //                                     index]
                                        //                                 ? Colors
                                        //                                     .white
                                        //                                 : Colors
                                        //                                     .grey)),
                                        //                     onPressed: () {
                                        //                       changeColorForCity[
                                        //                               index] =
                                        //                           !changeColorForCity[
                                        //                               index];
                                        //                       insertSelectedCity(
                                        //                           index);

                                        //                       if (isRemoveDepo[
                                        //                           index]) {
                                        //                         isRemoveDepo[
                                        //                                 index] =
                                        //                             false;
                                        //                         selectedDepo
                                        //                             .clear();
                                        //                         getDepoNames(
                                        //                                 cityData[
                                        //                                     index])
                                        //                             .then((_) {
                                        //                           getDepoLen();
                                        //                           provider
                                        //                               .setLoadWidget(
                                        //                                   true);
                                        //                         });
                                        //                       } else {
                                        //                         isRemoveDepo[
                                        //                                 index] =
                                        //                             true;
                                        //                         removeSelectedDepo(
                                        //                                 cityData[
                                        //                                     index])
                                        //                             .then(
                                        //                                 (_) => {
                                        //                                       provider.setLoadWidget(true)
                                        //                                     });
                                        //                       }
                                        //                     },
                                        //                     child: Text(
                                        //                       cityData[index],
                                        //                       style: TextStyle(
                                        //                           fontSize: 10,
                                        //                           color: changeColorForCity[
                                        //                                   index]
                                        //                               ? Colors
                                        //                                   .black
                                        //                               : Colors
                                        //                                   .white),
                                        //                     ),
                                        //                   ),
                                        //                 );
                                        //               },
                                        //             ),
                                        //           );
                                        //         },
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // const SizedBox(height: 10),
                                        // Consumer<MenuUserPageProvider>(
                                        //   builder: (BuildContext context,
                                        //       providerValue, Widget? child) {
                                        //     return Container(
                                        //       padding: const EdgeInsets.only(
                                        //           left: 10.0,
                                        //           top: 10.0,
                                        //           bottom: 10),
                                        //       child: Row(
                                        //         children: [
                                        //           Container(
                                        //             padding:
                                        //                 const EdgeInsets.only(
                                        //                     right: 10.0),
                                        //             child: SizedBox(
                                        //               width: 130,
                                        //               child: TextButton(
                                        //                 style: ButtonStyle(
                                        //                     backgroundColor:
                                        //                         MaterialStatePropertyAll(
                                        //                             Colors
                                        //                                 .grey)),
                                        //                 onPressed: () {},
                                        //                 child: const Text(
                                        //                   'Depots :',
                                        //                   style: TextStyle(
                                        //                       fontSize: 10,
                                        //                       fontWeight:
                                        //                           FontWeight
                                        //                               .bold,
                                        //                       color:
                                        //                           Colors.white),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //           ),
                                        //           Consumer<
                                        //               MenuUserPageProvider>(
                                        //             builder:
                                        //                 (BuildContext context,
                                        //                     providerValue,
                                        //                     Widget? child) {
                                        //               return Container(
                                        //                 decoration:
                                        //                     BoxDecoration(
                                        //                         boxShadow: [
                                        //                       BoxShadow(
                                        //                         color: Colors
                                        //                             .grey
                                        //                             .withOpacity(
                                        //                                 0.3),
                                        //                       )
                                        //                     ],
                                        //                         border: Border
                                        //                             .all()),
                                        //                 height: 150,
                                        //                 width: MediaQuery.of(
                                        //                             context)
                                        //                         .size
                                        //                         .width *
                                        //                     0.6,
                                        //                 child: Padding(
                                        //                   padding:
                                        //                       const EdgeInsets
                                        //                           .all(5.0),
                                        //                   child:
                                        //                       GridView.builder(
                                        //                           shrinkWrap:
                                        //                               true,
                                        //                           itemCount:
                                        //                               depodata
                                        //                                   .length,
                                        //                           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        //                               crossAxisCount:
                                        //                                   6,
                                        //                               crossAxisSpacing:
                                        //                                   10.0,
                                        //                               mainAxisSpacing:
                                        //                                   10.0,
                                        //                               mainAxisExtent:
                                        //                                   30,
                                        //                               childAspectRatio:
                                        //                                   9.0),
                                        //                           itemBuilder:
                                        //                               (context,
                                        //                                   index) {
                                        //                             if (isProjectManager) {
                                        //                               changeColorForDepo[
                                        //                                       index] =
                                        //                                   false;
                                        //                               insertSelectedDepo(
                                        //                                   index);
                                        //                             }

                                        //                             return ElevatedButton(
                                        //                                 style:
                                        //                                     ButtonStyle(
                                        //                                         backgroundColor:
                                        //                                             MaterialStatePropertyAll(
                                        //                                   changeColorForDepo[index]
                                        //                                       ? Colors.white
                                        //                                       : Colors.grey,
                                        //                                 )),
                                        //                                 onPressed:
                                        //                                     () {
                                        //                                   isProjectManager =
                                        //                                       false;
                                        //                                   changeColorForDepo[index] =
                                        //                                       !changeColorForDepo[index];
                                        //                                   insertSelectedDepo(
                                        //                                       index);
                                        //                                   providerValue
                                        //                                       .setLoadWidget(true);
                                        //                                 },
                                        //                                 child:
                                        //                                     Text(
                                        //                                   depodata[
                                        //                                       index],
                                        //                                   style: TextStyle(
                                        //                                       color: changeColorForDepo[index] ? Colors.black : Colors.white,
                                        //                                       fontSize: 10),
                                        //                                 ));
                                        //                           }),
                                        //                 ),
                                        //               );
                                        //             },
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     );
                                        //   },
                                        // ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  //Calculating Total users for additional screen
  Future<void> getTotalUsers() async {
    await getAssignedUsers();
    await getUnAssignedUser();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('TotalUsers').get();
    totalUsers = querySnapshot.docs.length;
  }

//Function for changing designation roles button color on tap
  void getDesigationLen() {
    List<bool> tempBool = [];
    for (int i = 0; i < designation.length; i++) {
      tempBool.add(true);
    }
    changeColorForRole = tempBool;
  }

  void getCityLen() {
    List<bool> tempBool = [];
    for (int i = 0; i < cityData.length; i++) {
      tempBool.add(true);
    }
    changeColorForCity = tempBool;
  }

//Function for changing depo name button color on tap
  void getDepoLen() {
    List<bool> tempListForDepo = [];
    for (int i = 0; i < depodata.length; i++) {
      tempListForDepo.add(true);
    }
    changeColorForDepo = tempListForDepo;
  }

  void insertSelectedRole(int currentIndex) {
    if (changeColorForRole[currentIndex] == false) {
      role.add(designation[currentIndex]);
    } else if (changeColorForRole[currentIndex] == true) {
      role.remove(designation[currentIndex]);
    }
  }

  void insertSelectedDepo(int currentIndex) {
    if (changeColorForDepo[currentIndex] == false) {
      selectedDepo.add(depodata[currentIndex]);
    } else if (changeColorForDepo[currentIndex] == true) {
      selectedDepo.remove(depodata[currentIndex]);
    }
  }

  void insertSelectedCity(int currentIndex) {
    if (changeColorForCity[currentIndex] == false) {
      selectedCity.add(cityData[currentIndex]);
    } else if (changeColorForCity[currentIndex] == true) {
      selectedCity.remove(cityData[currentIndex]);
    }
  }

//Function to fetch depo name when any city name is clicked on the pag Ce
  Future getDepoNames(String selectedCity) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('DepoName')
        .doc(selectedCity)
        .collection('AllDepots')
        .get();

    List<dynamic> temp = querySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < temp.length; i++) {
      depodata.add(temp[i]);
    }
  }

  Future<void> removeSelectedDepo(String selectedCity) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('DepoName')
        .doc(selectedCity)
        .collection('AllDepots')
        .get();

    List<dynamic> temp = querySnapshot.docs.map((e) => e.id).toList();
    for (int i = 0; i < temp.length; i++) {
      depodata.remove(temp[i]);
    }
  }

  Future<void> removeCityDepo(List<dynamic> cityList) async {
    for (int i = 0; i < cityList.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('DepoName')
          .doc(cityList[i])
          .collection('AllDepots')
          .get();

      List<dynamic> temp = querySnapshot.docs.map((e) => e.id).toList();
      for (int i = 0; i < temp.length; i++) {
        depodata.remove(temp[i]);
      }
    }
  }

  getUserdata(String input) async {
    searchedList.clear();
    getSocietyList();
    for (int i = 0; i < societyList.length; i++) {
      if (societyList[i].toUpperCase().startsWith(input.toUpperCase())) {
        searchedList.add(societyList[i]);
      }
    }
    // print(searchedList);
    societyList.clear();
    return searchedList;
  }

  // Future<void> setTotalUsers() async {
  //   FirebaseFirestore.instance.collection('User').get().then((value) {
  //     String tempData = '';
  //     value.docs.forEach((element) {
  //       var data = element['FirstName'];
  //       var data1 = element['LastName'];

  //       tempData = '${data.toString().trim()} $data1}';
  //       FirebaseFirestore.instance.collection('TotalUsers').doc(tempData).set(

  //           {'alphabet': tempData[0].toUpperCase(), 'position': 'unAssigned'}
  //           );
  //     });
  //   });
  // }

  Future<void> getUnAssignedUser() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('unAssignedRole').get();

    unAssignedUserList = querySnapshot.docs.map((e) => e.id).toList();
    unAssignedUser = querySnapshot.docs.length;
    unAssignedUserController.text = unAssignedUser.toString();
  }

  //Storing data in firebase
  Future<void> storeAssignData() async {
    if (userExist) {
      updateUserData(selectedUserName);
    } else {
      await FirebaseFirestore.instance
          .collection('AssignedRole')
          .doc(selectedUserName)
          .set({
        // 'username': selectedUserName.trim(),
        // 'userId': selectedUserId,
        'alphabet': selectedUserName[0][0].toUpperCase(),
        'position': 'Assigned',
        'roles': role,
        // 'depots': selectedDepo,
        'societyname': selectedSocietyName,
        // 'cities': selectedCity,
      }).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.grey,
          content: Text('Role Assigned Successfully'),
        ));
      });

      await FirebaseFirestore.instance
          .collection('TotalUsers')
          .doc(selectedUserName)
          .set({
        // 'userId': selectedUserId,
        'alphabet': selectedUserName[0][0].toUpperCase(),
        'position': 'Assigned',
        'roles': role,
        // 'depots': selectedDepo,
        'societyname': selectedSocietyName,
        // 'cities': selectedCity,
      });
    }
  }

  Future<List<dynamic>> getAssignedUsers() async {
    assignedUserList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('AssignedRole').get();

    assignedUserList = querySnapshot.docs.map((e) => e.id).toList();
    assignedUsers = querySnapshot.docs.length;
    return assignedUserList;
  }

  // ignore: non_constant_identifier_names
  UserCard(BuildContext context, int number, String title, Color color,
      Widget name) {
    final menuProvider =
        Provider.of<MenuUserPageProvider>(context, listen: true);
    return Column(
      children: [
        Container(
          width: 300,
          height: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '$number',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(title,
                    style: const TextStyle(fontSize: 13, color: Colors.white)),
              ]),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MultiProvider(providers: [
                          ChangeNotifierProvider(
                              create: (context) => MenuUserPageProvider()),
                          ChangeNotifierProvider(
                            create: (context) => FilterProvider(),
                          )
                        ], child: name);
                      })).then((value) {
                        getTotalUsers().whenComplete(() async {
                          isRemoveDepo =
                              List.generate(cityData.length, (index) => true);
                          errorMessage = '';
                          _controllerSociety.text = '';
                          _controllerForUser.text = '';
                          isProjectManager = false;
                          getDepoLen();
                          getCityLen();
                          getDesigationLen();
                          selectedDepo.clear();
                          role.clear();
                          removeCityDepo(selectedCity).then((_) {
                            selectedCity.clear();
                            menuProvider.setLoadWidget(true);
                          });
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                    ),
                    child: const Text('More Info'),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.forward),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Future<void> checkUserAlreadyExist(String username) async {
    showError = false;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('AssignedRole').get();
    List<dynamic> assignedUsers = querySnapshot.docs.map((e) => e.id).toList();
    for (int i = 0; i < assignedUsers.length; i++) {
      if (assignedUsers[i].toString().toUpperCase().trim() ==
          username.toUpperCase().trim()) {
        showError = true;
        errorMessage = 'Warning! User Already Assigned A Role';
        userExist = true;
      }
    }
  }

  Future<void> updateUserData(String username) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('AssignedRole')
        .doc(username)
        .get();

    List<dynamic> updatedRole = [];
    List<dynamic> updatedDepo = [];
    List<dynamic> updatedCity = [];

    Map<String, dynamic> tempData =
        documentSnapshot.data() as Map<String, dynamic>;
    List<dynamic> presentRoles = tempData['roles'];
    List<dynamic> presentDepots = tempData['depots'];
    List<dynamic> presentCities = tempData['cities'];

    updatedRole = presentRoles + role;
    updatedDepo = presentDepots + selectedDepo;
    updatedCity = presentCities + selectedCity;

    updatedRole = updatedRole.toSet().toList();
    updatedDepo = updatedDepo.toSet().toList();
    updatedCity = updatedCity.toSet().toList();

    await FirebaseFirestore.instance
        .collection('AssignedRole')
        .doc(selectedUserName)
        .update({
      'username': selectedUserName.trim(),
      'userId': selectedUserId,
      'alphabet': selectedUserName[0][0].toUpperCase(),
      'position': 'Assigned',
      'roles': updatedRole,
      'depots': updatedDepo,
      'societyname': selectedSocietyName,
      'cities': updatedCity,
    }).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.grey,
        content: Text('Role Assigned Successfully'),
      ));
    });

    await FirebaseFirestore.instance
        .collection('TotalUsers')
        .doc(selectedUserName)
        .update({
      'userId': selectedUserId,
      'alphabet': selectedUserName[0][0].toUpperCase(),
      'position': 'Assigned',
      'roles': updatedRole,
      'depots': updatedDepo,
      'societyname': selectedSocietyName,
      'cities': updatedCity,
    }).whenComplete(() {
      updatedCity.clear();
      updatedDepo.clear();
      updatedRole.clear();
    });
    // print('Updated');
  }

  Future<void> getCityName() async {
    List<bool> tempBool = [];
    List<String> tempCityName = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('CityName').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();

    for (int i = 0; i < tempList.length; i++) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('CityName')
          .doc(tempList[i])
          .get();

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      // cityData.add(data['CityName']);
      tempCityName.add(data['CityName']);
      tempBool.add(true);
    }

    cityData = tempCityName;
    isRemoveDepo = tempBool;
  }

  customAlertBox(String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 10,
            backgroundColor: Colors.white,
            icon: const Icon(
              Icons.warning_amber,
              size: 45,
              color: Colors.red,
            ),
            title: Text(
              message,
              style: const TextStyle(
                  color: Colors.grey, fontSize: 14, letterSpacing: 2),
            ),
          );
        });
  }

  Future<String> getSelectedUserId(String username) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('FirstName', isEqualTo: username)
        .get();

    List<dynamic> tempData = querySnapshot.docs.map((e) => e.data()).toList();
    Map<String, dynamic> data = tempData[0];

    selectedUserId = data['Employee Id'];

    return selectedUserId;
  }

  Future<void> getDataId(String username) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('User').get();

    List<dynamic> tempList = querySnapshot.docs.map((e) => e.id).toList();
    for (int i = 0; i < tempList.length; i++) {
      if (username
          .toString()
          .toUpperCase()
          .trim()
          .startsWith(tempList[i].toUpperCase().trim())) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc('${tempList[i]}')
            .get();

        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        selectedUserId = data['Employee Id'];
      }
    }
  }

  Future<void> getSocietyList() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('society').get();
    List<dynamic> temp = querySnapshot.docs.map((e) => e.id).toList();
    societyList = temp;
  }

  Future<List<dynamic>> getMemberList(String pattern) async {
    if (_controllerSociety.text.isNotEmpty) {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('members')
          .doc(_controllerSociety.text.trim())
          .get();
      Map<String, dynamic> temp =
          documentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> memberName = temp['data'];
      for (int i = 1; i < memberName.length; i++) {
        memberList.add(memberName[i]['Member Name']);
      }
      return memberList;
    } else {
      return ['please select society first'];
    }
  }
}

Widget searchWidget(String text) {
  return ListTile(
    title: Text(
      text.length > 4 ? text.substring(0, 4) : text,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.indigoAccent),
    ),
    subtitle: Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 12,
        color: Colors.black26,
      ),
    ),
  );
}
