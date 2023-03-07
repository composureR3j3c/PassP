import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ridee/AllScreens/LoginScreen.dart';
import 'package:ridee/AllScreens/SplashScreen.dart';
import 'package:ridee/AllScreens/searchScreen.dart';
import 'package:ridee/Globals/Global.dart';
import 'package:ridee/Helpers/OnPremMethods.dart';
import 'package:ridee/Helpers/sendMail.dart';
import 'package:ridee/Models/Users.dart';

import '../Helpers/assistantMethods.dart';

class DrawerWidget extends StatelessWidget {
  final String? name;
  final String? phone;
  final _storage = const FlutterSecureStorage();

  const DrawerWidget({Key? key, required this.name, required this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 255.0,
      child: Drawer(
        child: Column(
          children: [
            Container(
              height: 165,
              color: Colors.white,
              child: DrawerHeader(
                decoration: const BoxDecoration(color: Colors.red),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            name!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Text(
                            phone!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: () {
                // Navigator.pushReplacementNamed(context, '/');
              },
            ),
            // Divider(),
            // ListTile(
            //   leading: Icon(Icons.person),
            //   title: Text('Visit Profile'),
            //   onTap: () {
            //     // Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
            //   },
            // ),
            Divider(),
            // ListTile(
            //   leading: Icon(Icons.person),
            //   title: Text('Pre-Order'),
            //    onTap: () async {
            //                     DateTime? selectedDate= await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(DateTime.now().year),);

            //                     preorderTime=selectedDate;

            //                    var res = await Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                             builder: (context) => SearchScreen()));
            //                     if (res == "obtainDirection") {
            //                       await getPlaceDirections();
            //                       await drawPolyLineFromOriginToDestination();
            //                       displayRideDetail();
            //                     }
            //                   },
            // ),
            // Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                // Navigator.pushReplacementNamed(
                // context, UserProductScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.help_center),
              title: Text('Support'),
              onTap: () {
                sendMail();
                Navigator.pop(context);
                // Provider.of<Auth>(context, listen: false).logout();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () {
                _storage.deleteAll();
                var res =
                    OnPremMethods.premLoginOut(userModelCurrentInfo!.phone!);
                if (res != 404) {
                  userModelCurrentInfo = UserModel();

                  fAuth.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => LoginScreen()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
