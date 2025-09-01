import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/auth/models/trip.dart';
import 'package:travel_app/auth/services/json_load_service.dart';

//TODO: - load json, track favorites, list/grid selection, filters

enum ViewMode { list, grid }

class HomeController {
  final FirebaseFirestore _db;
  HomeController({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  // ui callback
  VoidCallback? onFavoritesChanged;

  List<Trip> _all = [];
  Set<String> _favoriteIds = {};
  ViewMode viewMode = ViewMode.list;

  String? country;
  String? region;
  String? category;
  DateTime? start;
  DateTime? end;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _favSub;

  List<Trip> get allTrips => _all;
  Set<String> get favorites => _favoriteIds;
  bool isFav(String id) => _favoriteIds.contains(id);

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

  List<Trip> filteredTrips() {
    return _all.where((t) {
      final cty = country == null || t.country == country;
      final reg = region == null || t.region == region;
      final ctgry = category == null || t.category == category;
      final date =
          (start == null && end == null) ||
          !(t.endDate.isBefore(start ?? t.endDate) ||
              t.startDate.isAfter(end ?? t.startDate));
      return cty && reg && ctgry && date;
    }).toList();
  }

  Future<void> dispose() async {
    await _favSub?.cancel();
  }
}
