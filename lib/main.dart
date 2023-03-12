import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridee/AllScreens/SplashScreen.dart';
import 'package:ridee/AllScreens/CancelScreen.dart';
import 'package:ridee/AllScreens/mainScreen.dart';
import 'package:ridee/Provider/appdata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  ByteData data = await PlatformAssetBundle().load('assets/ca/rideapi.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
          fontFamily: 'Roboto',
        ),
        home: MainScreen(),
        // home: MySplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
