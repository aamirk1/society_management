import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:society_management/screen/Sidebar.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

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
                        textInputAction: TextInputAction.next,
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: 'email', border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _passwordController,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            UserCredential userCredential =
                                await _auth.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            User? user = userCredential.user;
                            if (user != null) {
                              print('Logged in successfully: ${user.uid}');
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const Sidebar();
                              }));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor:
                                          Color.fromARGB(255, 28, 70, 0),
                                      content: Center(
                                        child: Text(
                                          'Login Successful',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 172, 172, 172),
                                            fontSize: 20,
                                          ),
                                        ),
                                      )));
                            }
                          } catch (e) {
                            print('An error occurred: $e');
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Center(
                                      child: Text(
                                        'Invalid Credentials',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    )));
                            // Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 0, 0, 0))))
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
