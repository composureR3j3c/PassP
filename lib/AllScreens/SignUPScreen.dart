import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ridee/Helpers/OnPremMethods.dart';
import '../Globals/Global.dart';
import '../Widgets/ProgressDialog.dart';
import 'LoginScreen.dart';
import 'SplashScreen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController LnameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (nameTextEditingController.text.length < 3 ||
        LnameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 Characters.");
    } else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    } else if (phoneTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone Number is required.");
    }  else if (!regExp.hasMatch(phoneTextEditingController.text)) {
      return 'Please enter valid mobile number';

    } 
     else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be atleast 6 Characters.");
    } else {
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      Map userMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference reference =
          FirebaseDatabase.instance.ref().child("users");
      reference.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      var response = await OnPremMethods.createUseronPrem(
          nameTextEditingController.text.trim(),
          LnameTextEditingController.text.trim(),
          phoneTextEditingController.text.trim(),
          emailTextEditingController.text.trim(),
          phoneTextEditingController.text.trim(),
          passwordTextEditingController.text.trim());
      print("response");
      print(response);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Account has been Created.");
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MySplashScreen()));
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(msg: "Account has not been Created.");
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
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
          //     image: DecorationImage(
          // image: AssetImage("images/USER-APP-REGISTER.jpg"),
          // fit: BoxFit.fill,
          // opacity: 1)),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 0),
                            child: Image.asset(
                              "images/logo.png",
                              opacity: const AlwaysStoppedAnimation(1),
                            ),
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
                  //   "Register as a user",
                  //   style: TextStyle(
                  //     fontSize: 26,
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  TextField(
                    controller: nameTextEditingController,
                    style: const TextStyle(color: Colors.black54),
                    decoration: const InputDecoration(
                      labelText: "Name",
                      hintText: "Name",
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
                    controller: LnameTextEditingController,
                    style: const TextStyle(color: Colors.black54),
                    decoration: const InputDecoration(
                      labelText: "Last Name",
                      hintText: "Last Name",
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
                    controller: phoneTextEditingController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.black54),
                    decoration: const InputDecoration(
                      labelText: "Phone",
                      hintText: "Phone",
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
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      "Already have an Account? Login Here",
                      style: TextStyle(color: Colors.amber),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => LoginScreen()));
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
