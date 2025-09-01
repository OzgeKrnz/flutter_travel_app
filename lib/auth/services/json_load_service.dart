import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:travel_app/auth/models/trip.dart';


class JsonLoader {
  static Future<List<Trip>> loadTrips() async {
    // dosya adını travel.json yap
    final raw = await rootBundle.loadString("assets/travels.json");
    final List<dynamic> list = json.decode(raw) as List<dynamic>;
    return list
        .map((e) => Trip.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}



