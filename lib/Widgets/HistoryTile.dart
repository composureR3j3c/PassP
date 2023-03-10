import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ridee/Globals/Global.dart';
import 'package:ridee/Models/address.dart';
import 'package:ridee/Models/historyPredictions.dart';
import 'package:ridee/Provider/appdata.dart';

class HistoryTile extends StatefulWidget {
  final HistoryPredictions historyPredictions;
  HistoryTile({required this.historyPredictions});

  @override
  State<HistoryTile> createState() => _PredictionTileState();
}

class _PredictionTileState extends State<HistoryTile> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Expanded(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                width: 20.0,
              ),
              SizedBox(
                width: 14.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15.0,
                  ),
                  Icon(
                    Icons.history,
                    color: Colors.red,
                    size: 20,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      SizedBox(
                        width: 8.0,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              "From: ",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                              )),
                            ),
                            Expanded(
                              child: Text(
                                widget.historyPredictions.mainText ?? "",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "To: ",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                            )),
                          ),
                          Expanded(
                            child: Text(
                              widget.historyPredictions.secondaryText ?? "",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Text(
                            "Date: ",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.lato(
                                textStyle: TextStyle(
                              color: Colors.black45,
                              fontSize: 16,
                            )),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.historyPredictions.date ?? "",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 13,
                              )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Row(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Status: ",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: 16,
                              )),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.historyPredictions.status ?? "",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))
                ],
              ),
              SizedBox(
                width: 14.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
