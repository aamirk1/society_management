import 'package:flutter/material.dart';
import 'package:society_management/listScreen/Ladger/MemberBillLadger.dart';
import 'package:society_management/listScreen/MemberList/ListOfMemberName.dart';
import 'package:society_management/listScreen/Receipt/MemberBillReceipt.dart';
import 'package:society_management/listScreen/societyListOfBill.dart';
import 'package:society_management/screen/assignRoll/user.dart';

// ignore: camel_case_types
class customSocietySide extends StatefulWidget {
  const customSocietySide({super.key, required this.societyNames});
  final String societyNames;

  @override
  State<customSocietySide> createState() => _customSocietySideState();
}

// ignore: camel_case_types
class _customSocietySideState extends State<customSocietySide> {
  List<String> tabTitle = [
    'Member List',
    'Role Assign',
    'Account List',
    'Bill List',
    'Receipt List',
  ];
  List<dynamic> tabIcon = [
    Icons.apartment_outlined,
    Icons.person,
    Icons.account_balance,
    Icons.receipt,
    Icons.receipt_outlined
  ];
  List<bool> design = [true, false, false, false, false];

  int _selectedIndex = 0;

  List<Widget> pages = [];

  @override
  Widget build(BuildContext context) {
    pages = [
      MemberNameList(societyName: widget.societyNames),
      MenuUserPage(societyName: widget.societyNames),
      societyListOfBill(societyName: widget.societyNames),
      MemberBillLadger(societyName: widget.societyNames),
      MemberBillReceipt(societyName: widget.societyNames),
    ];
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20),
            width: 250,
            color: Colors.purple,
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 40,
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Image.asset('assets/images/devlogo.png'),
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
                  : Colors.white),
          subtitle: Text(
            textAlign: TextAlign.center,
            title,
            style: const TextStyle(color: Colors.white),
          ),
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
      return MemberNameList(societyName: widget.societyNames);
    }
    return const Text('');
  }
}
