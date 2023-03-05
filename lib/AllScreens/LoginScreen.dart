import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ridee/Helpers/OnPremMethods.dart'; 

import '../Globals/Global.dart';
import '../Widgets/ProgressDialog.dart';
import 'SignUPScreen.dart';
import 'SplashScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

    validateForm() {
    if (!emailTextEditingController.text.contains("@")|| (emailTextEditingController.text.length>13)) {
      Fluttertoast.showToast(msg: "Email or Phone address is not Valid.");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required.");
    } else {
      loginUserNow();
    }
  }

  loginUserNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;
     var response = await OnPremMethods.premLoginIn(
      emailTextEditingController.text.trim(),
      passwordTextEditingController.text.trim(),
    );
    if (firebaseUser != null) {
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child("users");
      userRef.child(firebaseUser.uid).once().then((userKey) {
        final snap = userKey.snapshot;

        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
         
        }
         else {
         if (response != 404) {
          Fluttertoast.showToast(msg: "Login Successful.");
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
          userModelCurrentInfo!.name = response["profile"]["fname"];
          userModelCurrentInfo!.lname = response["profile"]["lname"];
          userModelCurrentInfo!.phone = response["profile"]["phone"];
          userModelCurrentInfo!.email = response["profile"]["email"];
          userModelCurrentInfo!.id = response["profile"]["deviceId"];
        } Fluttertoast.showToast(msg: "No record exist with this email.");
          fAuth.signOut();
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred during Login.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          // decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage("images/USER-APP-LOGIN.jpg"),
          //     fit: BoxFit.fill)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(80.0),
                      child: Column(
                        children: [
                          Image.asset(
                            "images/logo.png",
                            // opacity: const AlwaysStoppedAnimation(.6)
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "One Taxi",
                            style: GoogleFonts.pacifico(
                                textStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            )),
                          ),
                        ],
                      )),

                  // const Text(
                  // "Login as a User",
                  // style: TextStyle(
                  //   fontSize: 26,
                  //   color: Colors.black87,
                  //   fontWeight: FontWeight.bold,
                  // ),
                  // ),
                  TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.black54),
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "Email",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  TextField(
                    controller: passwordTextEditingController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    style: const TextStyle(color: Colors.black54),
                    decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      validateForm();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      "Do not have an Account? SignUp Here",
                      style: TextStyle(color: Colors.amber),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => SignUpScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
