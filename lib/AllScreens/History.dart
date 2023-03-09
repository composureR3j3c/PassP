import 'package:flutter/material.dart';
import 'package:ridee/Globals/Global.dart';
import 'package:ridee/Helpers/OnPremMethods.dart';
import 'package:ridee/Models/historyPredictions.dart';
import 'package:ridee/Models/placePrediction.dart';
import 'package:ridee/Widgets/Divider.dart';
import 'package:ridee/Widgets/HistoryTile.dart';
import 'package:ridee/Widgets/PredictionTile.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<HistoryPredictions> historyList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        GestureDetector(
          onTap: () async {
            fetcHistory();
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
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
              padding: const EdgeInsets.all(5.0),
              child: Row(children: [
                SizedBox(
                  width: 10.0,
                ),
                Icon(Icons.replay_outlined, color: Colors.white, size: 35),
                SizedBox(
                  width: 10.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Refresh",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
              ]),
            ),
          ),
        ),
        (historyList.length > 0)
            ? Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => HistoryTile(
                    historyPredictions: historyList[index],
                  ),
                  separatorBuilder: (BuildContext context, int Index) =>
                      DividerWidget(),
                  itemCount: historyList.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                ),
              )
            : Container(
                child: Center(
                  child: const Text("No History Yet"),
                ),
              )
      ],
    ));
  }

  void fetcHistory() async {
    var res = await OnPremMethods.getHistory(userModelCurrentInfo?.phone);
    if (res == 404) {
      return;
    } else
    // if (res["status"] == "OK")
    {
      print(res["results"]);
      var predictions = res["results"];
      var placeList = (predictions as List)
          .map((e) => HistoryPredictions.fromJson(e))
          .toList();
      setState(() {
        historyList = placeList;
      });
    }
  }
}
