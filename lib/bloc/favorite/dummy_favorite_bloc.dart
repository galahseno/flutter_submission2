import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dummy_favorite_event.dart';

part 'dummy_favorite_state.dart';

class DummyFavoriteBloc extends Bloc<DummyFavoriteEvent, DummyFavoriteState> {
  DummyFavoriteBloc() : super(DummyFavoriteInitial());

  @override
  Stream<DummyFavoriteState> mapEventToState(
    DummyFavoriteEvent event,
  ) async* {
    if (event is FavoriteDummyEvent) {
      if (event.favorite) {
        yield DummyFavoriteFill();
      } else {
        yield DummyFavoriteInitial();
      }
    }
    if (event is FavoriteDummyInitial) {
      yield DummyFavoriteInitial();
    }
  }
}
