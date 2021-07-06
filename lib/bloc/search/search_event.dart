part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchSubmitEvent extends SearchEvent {
  final String query;

  SearchSubmitEvent({required this.query});
}

class CloseSearchIcon extends SearchEvent {}
