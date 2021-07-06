part of 'list_restaurant_bloc.dart';

@immutable
abstract class ListRestaurantState {}

class ListRestaurantInitial extends ListRestaurantState {}

class ListRestaurantError extends ListRestaurantState {
  final String message;

  ListRestaurantError({required this.message});
}

class ListRestaurantLoaded extends ListRestaurantState {
  final List<Restaurants> listRestaurant;
  final double topContainer;

  ListRestaurantLoaded(
      {required this.listRestaurant, required this.topContainer});
}
