import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ridee/Globals/Global.dart';

class OnPremMethods {
  static Future<dynamic> createUseronPrem(String fname, String lname,
      String phone, String email, String deviceId, String pw) async {
    String url = "$premUrl/ride-app/register";
    String key =
        "Qq87PGWPscPQfzlCz4ralI7JtrGcZ6ymYxjGxxHOmTKsBPCxXxSDlZr5jjidQzi117kdaCggXtw8HQ9fS2CEsMdavclyeO4uN4D1Ymm4OTnzlGPeFFT5PPN1JEPWSS7w";
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': key,
    };

    Map Body = {
      "type": "passenger",
      "fname": fname,
      "lname": lname,
      "phone": phone,
      "email": email,
      "deviceId": deviceId,
      "pw": pw
    };
    http.Response httpResponse = await http.post(
      Uri.parse(url),
      body: jsonEncode(Body),
      headers: header,
    );
    return httpResponse;
  }

  static Future<dynamic> premLoginIn(String userName, String password) async {
    String url = "$premUrl/ride-app/login";
    String key =
        "Qq87PGWPscPQfzlCz4ralI7JtrGcZ6ymYxjGxxHOmTKsBPCxXxSDlZr5jjidQzi117kdaCggXtw8HQ9fS2CEsMdavclyeO4uN4D1Ymm4OTnzlGPeFFT5PPN1JEPWSS7w";
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': key,
    };

    Map Body = {
      "type": "passenger",
      "userName": userName,
      "password": password
    };
    try {
      http.Response httpResponse = await http.post(
        Uri.parse(url),
        headers: header,
        body: jsonEncode(Body),
      );
      if (httpResponse.statusCode == 200) {
        return jsonDecode(httpResponse.body);
      } else {
        return 404;
      }
    } catch (e) {
      return e;
    }
  }

  static Future<dynamic> premLoginOut(String userName) async {
    String url = "$premUrl/ride-app/logout";
    String key =
        "Qq87PGWPscPQfzlCz4ralI7JtrGcZ6ymYxjGxxHOmTKsBPCxXxSDlZr5jjidQzi117kdaCggXtw8HQ9fS2CEsMdavclyeO4uN4D1Ymm4OTnzlGPeFFT5PPN1JEPWSS7w";
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': key,
    };

    Map Body = {"type": "passenger", "userName": userName};
    try {
      http.Response httpResponse = await http.post(
        Uri.parse(url),
        headers: header,
        body: jsonEncode(Body),
      );
      if (httpResponse.statusCode == 200) {
        return jsonDecode(httpResponse.body);
      } else {
        return 404;
      }
    } catch (e) {
      return e;
    }
  }

  static Future<dynamic> getfare(int distance) async {
    String url = "$premUrl/ride-app/getFare?distance=$distance";
    String key =
        "Qq87PGWPscPQfzlCz4ralI7JtrGcZ6ymYxjGxxHOmTKsBPCxXxSDlZr5jjidQzi117kdaCggXtw8HQ9fS2CEsMdavclyeO4uN4D1Ymm4OTnzlGPeFFT5PPN1JEPWSS7w";
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': key,
    };

    try {
      http.Response httpResponse = await http.get(
        Uri.parse(url),
        headers: header,
      );
      if (httpResponse.statusCode == 200) {
        return jsonDecode(httpResponse.body);
      } else {
        return 404;
      }
    } catch (e) {
      return e;
    }
  }

  static Future<dynamic> requestRide(Map reqBody) async {
    String url = "$premUrl/ride-app/getDriver";
    String key =
        "Qq87PGWPscPQfzlCz4ralI7JtrGcZ6ymYxjGxxHOmTKsBPCxXxSDlZr5jjidQzi117kdaCggXtw8HQ9fS2CEsMdavclyeO4uN4D1Ymm4OTnzlGPeFFT5PPN1JEPWSS7w";
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': key,
    };

    try {
      http.Response httpResponse = await http.post(Uri.parse(url),
          headers: header, body: jsonEncode(reqBody));
      if (httpResponse.statusCode == 200) {
        return jsonDecode(httpResponse.body);
      } else {
        return 404;
      }
    } catch (e) {
      return e;
    }
  }

  static Future<dynamic> getTripDetail(String tripId) async {
    String url = "$premUrl/ride-app/getTrip?tripId=$tripId";
    String key =
        "Qq87PGWPscPQfzlCz4ralI7JtrGcZ6ymYxjGxxHOmTKsBPCxXxSDlZr5jjidQzi117kdaCggXtw8HQ9fS2CEsMdavclyeO4uN4D1Ymm4OTnzlGPeFFT5PPN1JEPWSS7w";
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': key,
    };
    try {
      http.Response httpResponse = await http.get(
        Uri.parse(url),
        headers: header,
      );
      if (httpResponse.statusCode == 200) {
        return jsonDecode(httpResponse.body);
      } else {
        return 404;
      }
    } catch (e) {
      return e;
    }
  }

  static Future<dynamic> getPaymentMethods() async {
    String url = "$premUrl/ride-app/getPaymentMethods";
    String key =
        "Qq87PGWPscPQfzlCz4ralI7JtrGcZ6ymYxjGxxHOmTKsBPCxXxSDlZr5jjidQzi117kdaCggXtw8HQ9fS2CEsMdavclyeO4uN4D1Ymm4OTnzlGPeFFT5PPN1JEPWSS7w";
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': key,
    };
    try {
      http.Response httpResponse = await http.get(
        Uri.parse(url),
        headers: header,
      );
      if (httpResponse.statusCode == 200) {
        return jsonDecode(httpResponse.body);
      } else {
        return 404;
      }
    } catch (e) {
      return e;
    }
  }

  static Future<dynamic> updateLocation(
      String? tripId, String? lat, String? lon) async {
    String url = "$premUrl/ride-app/getPaymentMethods";
    String key =
        "Qq87PGWPscPQfzlCz4ralI7JtrGcZ6ymYxjGxxHOmTKsBPCxXxSDlZr5jjidQzi117kdaCggXtw8HQ9fS2CEsMdavclyeO4uN4D1Ymm4OTnzlGPeFFT5PPN1JEPWSS7w";
    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': key,
    };
    Map Body = {
      "tripId": tripId,
      "path": {"x": lat, "y": lon}
    };
    try {
      http.Response httpResponse = await http.post(Uri.parse(url),
          headers: header, body: jsonEncode(Body));
      if (httpResponse.statusCode == 200) {
        return jsonDecode(httpResponse.body);
      } else {
        return 404;
      }
    } catch (e) {
      return e;
    }
  }
  // http://rideapi.gubanet.com/ride-app/tripRoute
}
