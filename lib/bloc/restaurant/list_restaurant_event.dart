part of 'list_restaurant_bloc.dart';

@immutable
abstract class ListRestaurantEvent {}

class LoadedEvent extends ListRestaurantEvent {
  final double value;

  LoadedEvent({required this.value});
}
