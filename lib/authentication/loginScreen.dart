import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:society_management/viewScreen/side.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 7, 180, 233),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                elevation: 10,
                child: Image.asset(
                  'assets/images/login_img.jpg',
                  height: 550,
                  width: 550,
                ),
              ),
              Card(
                elevation: 10,
                color: Colors.white,
                shadowColor: Colors.white70,
                child: Container(
                  padding: const EdgeInsets.all(70),
                  width: 550,
                  height: 550,
                  child: Column(children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Welcome! Kindly login",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.center,
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
                            labelText: 'Enter Your Email',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder()),
                      ),
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 7, 180, 233),
                          ),
                          minimumSize: MaterialStatePropertyAll(
                            Size(410, 50),
                          )),
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
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const customSide();
                            }));
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                    backgroundColor:
                                        Color.fromARGB(255, 45, 168, 109),
                                    content: Center(
                                      child: Text(
                                        'Login Successful',
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 20,
                                        ),
                                      ),
                                    )));
                          }
                        } catch (e) {
                          // print('An error occurred: $e');
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
                      // ignore: prefer_const_constructors, sort_child_properties_last
                      child: Text(
                        "Login",
                        // ignore: prefer_const_constructors
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
