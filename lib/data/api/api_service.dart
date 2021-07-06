import 'dart:convert';

import 'package:submission_1/data/model/Remote/restaurant_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _apiService = ApiService._internal();

  factory ApiService() {
    return _apiService;
  }

  ApiService._internal();

  static final _baseUrl = 'https://restaurant-api.dicoding.dev/list';
  static final _baseSearchUrl = 'https://restaurant-api.dicoding.dev/search?q=';
  static final baseImgUrl =
      'https://restaurant-api.dicoding.dev/images/medium/';

  Future<RestaurantResponse> getRestaurants() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return RestaurantResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load List Restaurant');
    }
  }

  Future<RestaurantResponse> searchRestaurants(String query) async {
    final response = await http.get(Uri.parse(_baseSearchUrl + query));
    if (response.statusCode == 200) {
      return RestaurantResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Restaurant not found');
    }
  }
}
