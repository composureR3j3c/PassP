import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ridee/AllScreens/LoginScreen.dart';
import 'package:ridee/Globals/Global.dart';
import 'package:ridee/Helpers/sendMail.dart';

import '../Helpers/assistantMethods.dart';

class DrawerWidget extends StatelessWidget {
  final String? name;
  final String? email;

  const DrawerWidget({Key? key, required this.name, required this.email})
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
                        Text(
                          name!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          email!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
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
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Visit Profile'),
              onTap: () {
                // Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Pre-Order'),
              onTap: () {
                // Navigator.pushReplacementNamed(context, OrdersScreen.routeName);
              },
            ),
            Divider(),
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
                fAuth.signOut();
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => LoginScreen()));

                // Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
