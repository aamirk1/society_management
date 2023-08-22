import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:society_management/authentication/loginScreen.dart';
import 'package:society_management/screen/AddCommittee.dart';
import 'package:society_management/screen/AddMember.dart';
import 'package:society_management/screen/AddSociety.dart';
import 'package:society_management/screen/HomeScreen.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  Widget selectedscreen = HomeScreen();
  currentItem(item) {
    switch (item.route) {
      case HomeScreen.id:
        setState(() {
          selectedscreen = HomeScreen();
        });
        break;
      case AddSociety.id:
        setState(() {
          selectedscreen = AddSociety();
        });
        break;
      case AddCommittee.id:
        setState(() {
          selectedscreen = AddCommittee();
        });
        break;
      case AddMember.id:
        setState(() {
          selectedscreen = AddMember();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
        appBar: AppBar(
          title: const Text("Society Management"),
          backgroundColor: Colors.blue.shade700,
        ),
        sideBar: SideBar(
          textStyle: TextStyle(
            fontSize: 15,
          ),
          onSelected: (item) {
            currentItem(item);
          },
          items: const [
            AdminMenuItem(
              title: "Home",
              icon: Icons.home_outlined,
              route: '/',
            ),
            AdminMenuItem(
              title: 'Add Society',
              icon: Icons.apartment_outlined,
              route: '/addSociety',
            ),
            AdminMenuItem(
              icon: Icons.supervised_user_circle_outlined,
              title: 'Add Committee Members',
              route: '/addCommittee',
            ),
            AdminMenuItem(
              title: 'Add Members',
              icon: Icons.supervised_user_circle_sharp,
              route: '/addMember',
            ),
          ],
          selectedRoute: HomeScreen.id,
        ),
        body: selectedscreen);
  }
}
