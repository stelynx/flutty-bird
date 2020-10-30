part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class InitializeEvent extends GameEvent {}

class StartEvent extends GameEvent {
  final bool eraseState;

  StartEvent(this.eraseState);
}

class PauseEvent extends GameEvent {}

class JumpEvent extends GameEvent {}

class UpdateScreenEvent extends GameEvent {
  final double deltaHeight;

  UpdateScreenEvent({@required this.deltaHeight});
}
