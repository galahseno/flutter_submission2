part of 'detail_bloc.dart';

@immutable
abstract class DetailState {}

class DetailInitial extends DetailState {}

class DetailLoaded extends DetailState {
  final DetailResponse detailResponse;

  DetailLoaded({required this.detailResponse});
}

class DetailError extends DetailState {
  final String message;

  DetailError({required this.message});
}
