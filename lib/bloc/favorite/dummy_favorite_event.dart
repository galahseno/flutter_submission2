part of 'dummy_favorite_bloc.dart';

@immutable
abstract class DummyFavoriteEvent {}

class FavoriteDummyInitial extends DummyFavoriteEvent {}

class FavoriteDummyEvent extends DummyFavoriteEvent {
  final bool favorite;

  FavoriteDummyEvent({required this.favorite});
}
