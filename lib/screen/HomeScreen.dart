// ignore: duplicate_ignore
// ignore: file_names
// ignore_for_file: file_names
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = '/';
  const HomeScreen({super.key});

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
        padding: const EdgeInsets.all(16.0),
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
                        decoration:
                            const InputDecoration(labelText: 'Unique ID'),
                      ),
                      TextFormField(
                        // controller: regNoController,
                        decoration: const InputDecoration(labelText: 'Reg No'),
                      ),
                      TextFormField(
                        // controller: emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0), // Add spacing between columns
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        // controller: adminNameController,
                        decoration:
                            const InputDecoration(labelText: 'Admin Name'),
                      ),
                      TextFormField(
                        // controller: contactController,
                        decoration: const InputDecoration(labelText: 'Contact'),
                      ),
                      TextFormField(
                        // controller: adminEmailController,
                        decoration:
                            const InputDecoration(labelText: 'Admin Email'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0), // Add spacing between rows
            ElevatedButton(
              onPressed: () {
                // Handle form submission here
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
        
        
        
