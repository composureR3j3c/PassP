class HistoryPredictions {
  String? secondaryText;
  String? mainText;
  String? date;
  String? placename;
  String? status;
  String? placeId;
  double? lat;
  double? lon;

  HistoryPredictions(
      {this.date,
      this.secondaryText,
      this.mainText,
      this.placeId,
      this.placename,
      this.status});

  HistoryPredictions.fromJson(Map<String, dynamic> json) {
    // placeId = json["place_id"];
    date = json["datetime"];
    secondaryText = json["tripDetail"]["to"]["name"];
    mainText = json["tripDetail"]["from"]["name"];

    // placename = json["placename"];
    status = json["tripStatus"];
  }
}
