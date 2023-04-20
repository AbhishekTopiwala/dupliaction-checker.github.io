import 'package:cloud_crud/screens/reset_password.dart';
import 'package:cloud_crud/screens/signup_screen.dart';
import 'package:cloud_crud/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../admin.dart';
import '../reuseable_widget/reuseable_widget.dart';
import '../student.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                SizedBox(
                  height: 150,
                  child: ColorFiltered(
                    colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    child: Image.asset("assets/images/search.png"),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseButton(context, "Log In", () {
                  if (_emailTextController.text.isEmpty || _passwordTextController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Alert"),
                          content: const Text("Username is required.\nPassword is required."),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }

                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text)
                      .then((userCredential) {
                    //  print(_emailTextController.text);
                    //print(_passwordTextController.text);

                    if (_emailTextController.text == "admin@gmail.com" &&
                        _passwordTextController.text == "admin3110") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Student()),
                      );
                    }
                  }).onError((error, stackTrace) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Alert"),
                          content: const Text("Wrong password.\nWrong ID."),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }


  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScrren()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 35,
        alignment: Alignment.bottomRight,
        child: TextButton(
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.right,
          ),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPassword())),
        ),
    );
  }
}
