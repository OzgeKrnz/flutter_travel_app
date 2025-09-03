import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/models/trip.dart';
import 'package:travel_app/auth/services/json_load_service.dart';
import 'package:travel_app/models/trip_filter.dart';

enum ViewMode { list, grid }

class HomeController {
  final FirebaseFirestore _db;
  HomeController({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  // ui callback
  VoidCallback? onFavoritesChanged;

  //data for trips
  List<Trip> _all = [];
  Set<String> _favoriteIds = {};
  ViewMode viewMode = ViewMode.list;

  // filtreleme durumu
  String? country;
  String? region;
  String? category;
  DateTime? start;
  DateTime? end;
  bool onlyFavorites = false;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _favSub;

  List<Trip> get allTrips => _all;
  Set<String> get favorites => _favoriteIds;
  bool isFav(String id) => _favoriteIds.contains(id);

  TripFilter get filter => TripFilter(
    country: country,
    region: region,
    category: category,
    dateRange: (start != null && end != null)
        ? DateTimeRange(start: start!, end: end!)
        : null,
    onlyFavorites: onlyFavorites,
  );


  // dropdown
  List<String> get countries => 
      (_all.map((t) => t.country).where((e) => e.isNotEmpty).toSet().toList()..sort());

    List<String> get regions {
      final src = (country == null) ? _all : _all.where((t) => t.country == country);
      return (src.map((t) => t.region).where((e) => e.isNotEmpty).toSet().toList()..sort());
  }
  List<String> get categories =>
    (_all.map((t) => t.category).where((e) => e.isNotEmpty).toSet().toList()..sort());



  

  Future<void> init(String uid) async {
    //- load json
    _all = await JsonLoader.loadTrips();

    // track favs
    _favSub = _db
        .collection('favorites')
        .doc(uid)
        .collection('trips')
        .snapshots()
        .listen((snap) {
          final ids = <String>{};

          for (final d in snap.docs) {
            if ((d.data()['isFavorite'] as bool?) == true) ids.add(d.id);
          }
          _favoriteIds = ids;
          onFavoritesChanged?.call();
        });
  }

   Future<void> dispose() async {
    await _favSub?.cancel();
  }

  Future<void> toggleFavorite(String uid, Trip t) async {
    final nowFav = !_favoriteIds.contains(t.id);
    await _db
        .collection('favorites')
        .doc(uid)
        .collection('trips')
        .doc(t.id)
        .set({'isFavorite': nowFav, 'updateAt': FieldValue.serverTimestamp()});
  }

  void toggleView() {
    viewMode = viewMode == ViewMode.list ? ViewMode.grid : ViewMode.list;
  }

// FILTERBAR CALLBACK 
  void setCountry(String? v) => country = v;
  void setRegion(String? v) => region = v;
  void setCategory(String? v) => category = v;

  void setDateRange(DateTimeRange r) {
    start = r.start;
    end = r.end;
  }

  void setOnlyFavorites(bool v) => onlyFavorites = v;

  void clearFilter() {
    country = null;
    region = null;
    category = null;
    start = null;
    end = null;
    onlyFavorites = false;
  }

  //

  List<Trip> filteredTrips() {
    final base = applyFilter(
      _all,
      TripFilter(
        country: country,
        region: region,
        category: category,
        dateRange: (start != null && end != null) ? DateTimeRange(start: start!, end: end!) : null,
        onlyFavorites: false,
      ),
    );

    if (onlyFavorites) {
      return base.where((t) => _favoriteIds.contains(t.id)).toList()
        ..sort((a, b) => a.startDate.compareTo(b.startDate));
    }

    return base;
  }


}
