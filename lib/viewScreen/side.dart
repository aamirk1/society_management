import 'package:collapsible_sidebar/collapsible_sidebar.dart';
import 'package:collapsible_sidebar/collapsible_sidebar/collapsible_item.dart';
import 'package:flutter/material.dart';

void main() => runApp(const TabBarApp());

class TabBarApp extends StatelessWidget {
  const TabBarApp({super.key});

  Widget _body(Size size, BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blueGrey[50],
    );
  }

  List<CollapsibleItem> get _items {
    return [
      CollapsibleItem(
          text: 'Add Member',
          iconImage: const AssetImage(
              "assets/shop_icon.png"), //`iconImage` has priority over `icon` property
          icon: Icons.ac_unit,
          onPressed: () {},
          onHold: () {},
          isSelected: true,
          subItems: [
            // CollapsibleItem(
            //   text: 'Cart',
            //   icon: Icons.shopping_cart,
            //   onPressed: () {},
            //   onHold: () {},
            //   isSelected: true,
            // )
          ]),
      CollapsibleItem(
          text: 'Add Society',
          icon: Icons.assessment,
          onPressed: () {},
          onHold: () {},
          isSelected: false),
      CollapsibleItem(
          text: 'Add Committee',
          icon: Icons.icecream,
          onPressed: () {},
          onHold: () {},
          isSelected: false),
      // CollapsibleItem(
      //   text: 'Search',
      //   icon: Icons.search,
      //   onPressed: () => setState(() => _headline = 'Search'),
      //   onHold: () => ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: const Text("Search"))),
      // ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: CollapsibleSidebar(
        isCollapsed: MediaQuery.of(context).size.width <= 2000,
        items: _items,
        // avatarImg: _avatarImg,
        title: 'Home',
        body: _body(Size.zero, context),
      ),
    );
  }
}
