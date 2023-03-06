import 'package:flutter/material.dart';
import 'package:ridee/Helpers/OnPremMethods.dart';

import '../Globals/Global.dart';

var list = <Map>[
  {"name": "Cash", "code": "cash"},
  {"name": "Telebirr", "code": "telebirr"},
  {"name": "Bank Transfer", "code": "bankTxn"}
];

class DropdownButtonCash extends StatefulWidget {
  const DropdownButtonCash({Key? key}) : super(key: key);
  @override
  State<DropdownButtonCash> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonCash> {
  String dropdownValue = list.first["code"];

  // void initState() async {
  //   // TODO: implement initState
  //   super.initState();

  //   var res =  await OnPremMethods.getPaymentMethods();
  //   list = <Map>[res];
  // }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black87),
      underline: Container(
        height: 2,
        color: Colors.black54,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          finalDropdownValue = dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((Map value) {
        return DropdownMenuItem<String>(
          value: value["code"],
          child: Text(value["name"]),
        );
      }).toList(),
    );
  }
}
