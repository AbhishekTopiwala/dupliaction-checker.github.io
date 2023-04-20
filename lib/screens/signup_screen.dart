import 'package:cloud_crud/reuseable_widget/reuseable_widget.dart';
import 'package:cloud_crud/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

class SignUpScrren extends StatefulWidget {
  const SignUpScrren({Key? key}) : super(key: key);

  @override
  State<SignUpScrren> createState() => _SignUpScrrenState();
}

class _SignUpScrrenState extends State<SignUpScrren> {
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("232946"),
              hexStringToColor("B2B2B2"),
              hexStringToColor("232946")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter UserName", Icons.person_outline, false,
                  _userNameTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Email Id", Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", Icons.person_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 20,
              ),
              firebaseButton(context, "Sign Up", () {
                if (_emailTextController.text.isEmpty || _passwordTextController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Please fill all the details"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text)
                      .then((value) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Account created successfully"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }).onError((error, stackTrace) {
                    // ignore: avoid_print
                    print("Error ${error.toString()}");
                  });
                }
              })

            ],
          ),
        )),
      ),
    );
  }
}
