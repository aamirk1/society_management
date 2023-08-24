import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/';
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Home"),
      //   backgroundColor: Colors.blueGrey.shade700,
      // ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        // controller: uniqueIdController,
                        decoration: InputDecoration(labelText: 'Unique ID'),
                      ),
                      TextFormField(
                        // controller: regNoController,
                        decoration: InputDecoration(labelText: 'Reg No'),
                      ),
                      TextFormField(
                        // controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.0), // Add spacing between columns
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        // controller: adminNameController,
                        decoration: InputDecoration(labelText: 'Admin Name'),
                      ),
                      TextFormField(
                        // controller: contactController,
                        decoration: InputDecoration(labelText: 'Contact'),
                      ),
                      TextFormField(
                        // controller: adminEmailController,
                        decoration: InputDecoration(labelText: 'Admin Email'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0), // Add spacing between rows
            ElevatedButton(
              onPressed: () {
                // Handle form submission here
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
        
        
        
        
        
        
//         Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Column(
//           children: [
//             Text("dat4535a"),
//             Text("224tgtr lkjs6 chyjnm"),
//             Text("data"),
//             Text("224tgtr lkjs6 chyjnm"),
//             Text("data"),
//             Text("224tgtr lkjs6 chyjnm"),
//           ],
//         ),
//         Column(
//           children: [
//             Text("data"),
//             Text("224tgtr lkjs6 chyjnm"),
//             Text("data"),
//             Text("224tgtr lkjs6 chyjnm"),
//           ],
//         )
//       ],
//     ));
//   }
// }
