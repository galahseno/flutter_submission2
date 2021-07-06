import 'package:submission_1/data/api/api_service.dart';
import 'package:submission_1/data/model/Remote/restaurant_response.dart';

class DataProvider {
  final _apiService = ApiService();

  Future<RestaurantResponse> getRestaurants() async {
    return _apiService.getRestaurants();
  }

  Future<RestaurantResponse> searchRestaurants(String query) async {
    return _apiService.searchRestaurants(query);
  }
}
