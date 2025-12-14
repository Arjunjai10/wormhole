part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameStarted extends GameEvent {}

class ShotFired extends GameEvent {}

class LevelWon extends GameEvent {}

class LevelLost extends GameEvent {}

class NextLevelRequested extends GameEvent {}

class RetryRequested extends GameEvent {}
