import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'toolbar_event.dart';
part 'toolbar_state.dart';

class ToolbarBloc extends Bloc<ToolbarEvent, ToolbarState> {
  ToolbarBloc() : super(ToolbarMove());

  @override
  Stream<ToolbarState> mapEventToState(
    ToolbarEvent event,
  ) async* {
    if (event is ToolbarMoveSelected)
      yield* _mapToolbarMoveSelectedToState(event);
    else if (event is ToolbarDeleteSelected)
      yield* _mapToolbarDeleteSelectedToState(event);
    else if (event is ToolbarPaintSelected)
      yield* _mapToolbarPaintSelectedToState(event);
    else if (event is ToolbarPlaceSelected)
      yield* _mapToolbarPlaceSelectedToState(event);
  }

  Stream<ToolbarState> _mapToolbarMoveSelectedToState(
      ToolbarMoveSelected event) async* {
    yield ToolbarMove();
  }

  Stream<ToolbarState> _mapToolbarDeleteSelectedToState(
      ToolbarDeleteSelected event) async* {
    yield ToolbarDelete();
  }

  Stream<ToolbarState> _mapToolbarPaintSelectedToState(
      ToolbarPaintSelected event) async* {
    yield ToolbarPaint();
  }

  Stream<ToolbarState> _mapToolbarPlaceSelectedToState(
      ToolbarPlaceSelected event) async* {
    yield ToolbarPlace();
  }
}
