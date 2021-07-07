part of 'toolbar_bloc.dart';

@immutable
abstract class ToolbarEvent extends Equatable {
  const ToolbarEvent();

  @override
  get props => [];
}

class ToolbarMoveSelected extends ToolbarEvent {
  const ToolbarMoveSelected();
}

class ToolbarPaintSelected extends ToolbarEvent {
  const ToolbarPaintSelected();
}

class ToolbarDeleteSelected extends ToolbarEvent {
  const ToolbarDeleteSelected();
}

class ToolbarPlaceSelected extends ToolbarEvent {
  const ToolbarPlaceSelected();
}
