import 'package:flutter/material.dart';
import 'package:society_management/screen/Sidebar.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Welcome! Kindly login",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                child: Container(
                  // width: 400,
                  // height: 500,
                  child: Image.asset(
                    'assets/images/login_img.jpg',
                    height: 500,
                    width: 550,
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                shadowColor: Colors.white70,
                child: Container(
                  padding: EdgeInsets.all(70),
                  width: 550,
                  height: 500,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          "assets/images/devlogo.png",
                          height: 60,
                          width: 80,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        style: TextStyle(),
                        decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Sidebar();
                        }));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 0, 0, 0))),
                    )
                  ]),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
