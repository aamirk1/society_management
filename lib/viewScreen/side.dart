import 'package:flutter/material.dart';
import 'package:society_management/listScreen/Ladger/ListOfBillLadger.dart';
import 'package:society_management/listScreen/Receipt/ListOfBillReceipt.dart';
import 'package:society_management/listScreen/societyListOfBill.dart';
import 'package:society_management/listScreen/societyListOfMember.dart';
import 'package:society_management/screen/assignRoll/user.dart';

import '../listScreen/societyList.dart';

// ignore: camel_case_types
class customSide extends StatefulWidget {
  const customSide({super.key});

  @override
  State<customSide> createState() => _customSideState();
}

// ignore: camel_case_types
class _customSideState extends State<customSide> {
  List<String> tabTitle = [
    'Society List',
    'Member List',
    'Role List',
    'Accounts',
    'Ladger Bill',
    'Ladger Receipt',
  ];
  List<dynamic> tabIcon = [
    Icons.apartment_outlined,
    Icons.supervised_user_circle_outlined,
    Icons.house_rounded,
    Icons.house_outlined,
    Icons.account_balance_outlined,
    Icons.account_balance_wallet_outlined,
  ];
  List<bool> design = [true, false, false, false, false, false];

  int _selectedIndex = 0;

  List<Widget> pages = [
    const societyList(),
    const societyListOfMemberOfMember(),
    const MenuUserPage(),
    const societyListOfBill(),
    const ListOfBillLadger(),
    const ListOfBillReceipt(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            width: 250,
            color: const Color.fromARGB(255, 231, 239, 248),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 40,
                  padding: const EdgeInsets.only(bottom: 10),
                  child:  Image.asset('assets/images/devlogo.png'),
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
        setDesignBool();
        _selectedIndex = index;
        design[index] = !design[index];
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          title: Icon(icon,
              size: 30,
              color: design[index]
                  ? const Color.fromARGB(255, 8, 8, 8)
                  : const Color.fromARGB(95, 134, 134, 134)),
          subtitle: Text(textAlign: TextAlign.center, title),
        ),
      ),
    );
  }

  void setDesignBool() {
    List<bool> tempBool = [];
    for (int i = 0; i < 6; i++) {
      tempBool.add(false);
    }
    design = tempBool;
  }

  Widget getPage(int index) {
    if (index == 0) {
      return const societyList();
    }
    return const Text('');
  }
}
