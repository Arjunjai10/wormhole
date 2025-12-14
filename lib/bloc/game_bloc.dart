import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState.initial()) {
    on<GameStarted>(_onGameStarted);
    on<ShotFired>(_onShotFired);
    on<LevelWon>(_onLevelWon);
    on<LevelLost>(_onLevelLost);
    on<NextLevelRequested>(_onNextLevelRequested);
    on<RetryRequested>(_onRetryRequested);
    on<AutoPlayRequested>(_onAutoPlayRequested);
  }

  void _onGameStarted(GameStarted event, Emitter<GameState> emit) {
    emit(GameState.initial());
  }

  void _onShotFired(ShotFired event, Emitter<GameState> emit) {
    emit(state.copyWith(shotCount: state.shotCount + 1));
  }

  void _onLevelWon(LevelWon event, Emitter<GameState> emit) {
    // Calculate score based on shots - theoretical example
    final levelScore = (10 - state.shotCount).clamp(1, 10);
    emit(state.copyWith(
      status: GameStatus.won,
      totalScore: state.totalScore + levelScore,
    ));
  }

  void _onLevelLost(LevelLost event, Emitter<GameState> emit) {
    emit(state.copyWith(status: GameStatus.lost));
  }

  void _onNextLevelRequested(NextLevelRequested event, Emitter<GameState> emit) {
    emit(state.copyWith(
      levelIndex: state.levelIndex + 1,
      shotCount: 0,
      status: GameStatus.playing,
    ));
  }

  void _onRetryRequested(RetryRequested event, Emitter<GameState> emit) {
    emit(state.copyWith(
      shotCount: 0,
      status: GameStatus.playing,
    ));
  }

  void _onAutoPlayRequested(AutoPlayRequested event, Emitter<GameState> emit) {
    if (state.autoPlayCount > 0) {
      emit(state.copyWith(autoPlayCount: state.autoPlayCount - 1));
    }
  }
}
