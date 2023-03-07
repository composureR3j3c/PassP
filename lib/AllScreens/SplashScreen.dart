import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Globals/Global.dart';
import '../Helpers/assistantMethods.dart';
import 'LoginScreen.dart';
import 'mainScreen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  final _storage = const FlutterSecureStorage();
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      var logdName = await _storage.read(key: "name");
      if (userModelCurrentInfo?.id != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      } else if (logdName != null) {
        userModelCurrentInfo?.name = await _storage.read(key: "name");
        userModelCurrentInfo?.lname = await _storage.read(key: "lname");
        userModelCurrentInfo?.id = await _storage.read(key: "id");
        userModelCurrentInfo?.phone = await _storage.read(key: "phone");
        userModelCurrentInfo?.email = await _storage.read(key: "email");
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logo.png"),
              const SizedBox(
                height: 10,
              ),
              Text(
                "One Taxi",
                style: GoogleFonts.pacifico(
                    textStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
