import 'package:flutter/material.dart';
import 'package:ridee/Models/placePrediction.dart';
import 'package:ridee/Widgets/Divider.dart';
import 'package:ridee/Widgets/PredictionTile.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<PlacePredictions> historyList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) => PredictionTile(
          placePredictions: historyList[index],
        ),
        separatorBuilder: (BuildContext context, int Index) => DividerWidget(),
        itemCount: historyList.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    ));
  }
}
