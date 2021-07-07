part of 'toolbar_bloc.dart';

abstract class ToolbarState extends Equatable {
  @override
  get props => [];
}

class ToolbarMove extends ToolbarState {}

class ToolbarPlace extends ToolbarState {}

class ToolbarPaint extends ToolbarState {}

class ToolbarDelete extends ToolbarState {}
