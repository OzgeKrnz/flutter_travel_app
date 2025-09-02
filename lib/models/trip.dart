class Trip {
  final String id;
  final String title;
  final String country;
  final String region;
  final DateTime startDate;
  final DateTime endDate;
  final String category;
  final String description;
  final bool isFavorite;

  Trip({
    required this.id,
    required this.title,
    required this.country,
    required this.region,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.description,
    this.isFavorite = false,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json["id"] as String,
      title: json["title"] as String,
      country: json["country"] as String,
      region: json["region"] as String,
      startDate: DateTime.parse(json["startDate"] as String),
      endDate: DateTime.parse(json["endDate"] as String),
      category: json["category"] as String,
      description: json["description"] as String,
      isFavorite: json["isFavorite"] as bool? ?? false,
    );
  }

  // json decode
  Map<String, dynamic> toJson() {
    return {
      "id": id, 
      "title": title,
      "country": country,
      "region": region,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
      "category": category,
      "description": description,
      "isFavorite": isFavorite,
    };
  }
}
