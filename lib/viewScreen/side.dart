import 'package:flutter/material.dart';

import '../listScreen/committeeList.dart';
import '../listScreen/societyList.dart';
import '../screen/AddMember.dart';

class customSide extends StatefulWidget {
  const customSide({super.key});

  @override
  State<customSide> createState() => _customSideState();
}

// ignore: camel_case_types
class _customSideState extends State<customSide> {
  List<String> tabTitle = ['Society List', 'Member List', 'Manager List'];
  List<dynamic> tabIcon = [
    Icons.apartment_outlined,
    Icons.supervised_user_circle_outlined,
    Icons.house_rounded
  ];
  List<bool> design = [true, false, false];

  int _selectedIndex = 0;

  List<Widget> pages = [
    societyList(),
    AddMember(),
    const committeeList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30),
            width: 250,
            color: const Color.fromARGB(255, 231, 231, 231),
            child: Column(
              children: [
                Container(
                  width: 250,
                  height: 100,
                  child: Image.asset('assets/images/devlogo.png'),
                  padding: const EdgeInsets.only(bottom: 10),
                ),
                const Divider(
                  color: Colors.black,
                ),
                ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tabIcon.length,
                    itemBuilder: (context, index) {
                      return customListTile(
                          tabTitle[index], tabIcon[index], index);
                    })
              ],
            ),
          ),
          Expanded(child: pages[_selectedIndex])
        ],
      ),
    );
  }

  Widget customListTile(String title, dynamic icon, int index) {
    return InkWell(
      onTap: () {
        _selectedIndex = index;
        design[index] = !design[index];
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          title: Icon(icon,
              size: 50,
              color: design[index]
                  ? const Color.fromARGB(97, 94, 94, 94)
                  : Colors.black),
          subtitle: Text(textAlign: TextAlign.center, title),
        ),
      ),
    );
  }

  Widget getPage(int index) {
    if (index == 0) {
      return societyList();
    }
    return const Text('');
  }
}