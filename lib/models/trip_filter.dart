import 'package:flutter/material.dart' show DateTimeRange;
import 'package:travel_app/models/trip.dart';

class TripFilter {
  final String? country;
  final String? region;
  final String? category;
  final DateTimeRange? dateRange;
  final bool onlyFavorites;

  const TripFilter({
    this.country,
    this.region,
    this.category,
    this.dateRange,
    this.onlyFavorites = false,
  });
}

bool _overlaps(DateTime xStart, DateTime xEnd, DateTime yStart, DateTime yEnd) {
  return (xEnd.isAtSameMomentAs(yStart) || xEnd.isAfter(yStart)) &&
      (xStart.isAtSameMomentAs(yEnd) || xStart.isBefore(yEnd));
}


List<Trip> applyFilter(List<Trip> all, TripFilter f){
    final out = all.where((t) {
    if (f.country != null && t.country != f.country) return false;
    if (f.region  != null && t.region  != f.region)  return false;
    if (f.category!= null && t.category!= f.category) return false;
    if (f.onlyFavorites && !t.isFavorite) return false;

    if (f.dateRange != null) {
      final s = f.dateRange!.start;
      final e = f.dateRange!.end;
      if (!_overlaps(t.startDate, t.endDate, s, e)) return false;
    }
    return true;
  }).toList();

  out.sort((a,b) => a.startDate.compareTo(b.startDate));
  return out;
}
