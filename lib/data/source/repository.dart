import 'package:submission_1/data/model/Remote/restaurant_response.dart';
import 'package:submission_1/data/model/remote/detail/customer_reviews.dart';
import 'package:submission_1/data/model/remote/detail/detail_restaurant_response.dart';
import 'package:submission_1/data/source/data_provider.dart';

class Repository {
  static final Repository _repository = Repository._internal();

  factory Repository() {
    return _repository;
  }

  Repository._internal();

  final _dataProvider = DataProvider();

  Future<RestaurantResponse> getRestaurants() async {
    return await _dataProvider.getRestaurants();
  }

  Future<RestaurantResponse> searchRestaurants(String query) async {
    return await _dataProvider.searchRestaurants(query);
  }

  Future<DetailResponse> getDetailRestaurants(String id) async {
    return await _dataProvider.getDetailRestaurant(id);
  }

  Future postReview(String id, String name, String review) async {
    var postReview = CustomerReviews(id: id, name: name, review: review);
    return await _dataProvider.postReview(postReview, id);
  }
}
