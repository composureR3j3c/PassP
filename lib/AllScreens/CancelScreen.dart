import 'package:flutter/material.dart';
import 'package:ridee/Globals/Global.dart';



Future<void> showCancelDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black54,
        title: const Text('Cancel Reason',style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: ListBody(
            children:  <Widget>[
               GestureDetector(
                onTap: () async {
                   Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 6.0,
                          spreadRadius: 0.4,
                          offset: Offset(1, 1),
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                             
                              Icon(Icons.wrong_location,
                                  color: Colors.white, size: 30),
                              SizedBox(width:5.0),
                              Text(
                  "Accedental request",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 8.0,),
              GestureDetector(
                onTap: () async {
                  cancelReason = "Driver Asked to Cancel";
                   Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 6.0,
                          spreadRadius: 0.4,
                          offset: Offset(1, 1),
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                             
                              Icon(Icons.wrong_location,
                                  color: Colors.white, size: 30),
                              SizedBox(width:5.0),
                              Text(
                                "Driver asked to cancel",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 8.0,),
              GestureDetector(
                onTap: () async {
                   cancelReason = "Driver is too far";
                    Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 6.0,
                          spreadRadius: 0.4,
                          offset: Offset(1, 1),
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wrong_location,
                                  color: Colors.white, size: 30),
                                  SizedBox(width:5.0),
                              Text(
                                "Driver is too far",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
              
                SizedBox(height: 8.0,),
                GestureDetector(
                onTap: () async {
                   cancelReason = "Fare is too high";
                    Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red[800],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 6.0,
                          spreadRadius: 0.4,
                          offset: Offset(1, 1),
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wrong_location,
                                  color: Colors.white, size: 30),
                                  SizedBox(width:5.0),
                              Text(
                                "Fare is too high",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Don't cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

