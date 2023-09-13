import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:society_management/listScreen/committeeList.dart';
import 'package:society_management/listScreen/societyList.dart';
import 'package:society_management/screen/AddMember.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  Widget selectedscreen = societyList();
  currentItem(item) {
    switch (item.route) {
      // case HomeScreen.id:
      //   setState(() {
      //     selectedscreen = HomeScreen();
      //   });
      //   break;
      case societyList.id:
        setState(() {
          selectedscreen = societyList();
        });
        break;
      case committeeList.id:
        setState(() {
          selectedscreen = committeeList();
        });
        break;
      case AddMember.id:
        setState(() {
          selectedscreen = const AddMember();
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
        activeBackgroundColor: Color.fromARGB(255, 230, 230, 227),
        iconColor: Color.fromARGB(255, 12, 12, 12),
        textStyle: const TextStyle(
          fontSize: 15,
        ),
        onSelected: (item) {
          currentItem(item);
        },
        items: const [
          // AdminMenuItem(
          //   title: "Home",
          //   icon: Icons.home_outlined,
          //   route: '/',
          // ),
          AdminMenuItem(
            title: 'Society List',
            icon: Icons.apartment_outlined,
            route: '/societyList',
          ),

          AdminMenuItem(
            icon: Icons.supervised_user_circle_outlined,
            title: 'Committee List',
            route: '/committeeList',
          ),
          AdminMenuItem(
            title: 'Add Members',
            icon: Icons.supervised_user_circle_sharp,
            route: '/addMember',
          ),
        ],
        selectedRoute: '/societyList',
      ),
      body: selectedscreen,
    );
  }
}
