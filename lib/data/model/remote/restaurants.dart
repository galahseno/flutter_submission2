class Restaurants {
  late String id;
  late String name;
  late String pictureId;
  late String city;
  late dynamic rating;

  Restaurants(
      {required this.id,
      required this.name,
      required this.pictureId,
      required this.city,
      required this.rating});

  Restaurants.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    pictureId = json["pictureId"];
    city = json["city"];
    rating = json["rating"];
  }
}
