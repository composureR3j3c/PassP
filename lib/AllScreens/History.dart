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

  void initState() {
    // TODO: implement initState
    super.initState();
    fetcHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSize(
      curve: Curves.bounceIn,
      duration: const Duration(milliseconds: 10),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () async {
                  fetcHistory();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
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
                        horizontal: 23.0, vertical: 17.5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(Icons.replay_outlined,
                                  color: Colors.white, size: 35),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "Reload",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                    ),
                  ),
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
        ),
      ),
    ));
  }

  void fetcHistory() async {
    var res = await OnPremMethods.getHistory(userModelCurrentInfo?.phone);
    if (res == 404) {
      return;
    } else
    // if (res["status"] == "OK")
    {
      print(res.toString());
      var predictions = res;
      var placeList = (predictions as List)
          .map((e) => HistoryPredictions.fromJson(e))
          .toList();
      setState(() {
        historyList = placeList;
      });
    }
  }
}
