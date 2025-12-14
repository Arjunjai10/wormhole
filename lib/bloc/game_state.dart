part of 'game_bloc.dart';

enum GameStatus { playing, won, lost }

class GameState extends Equatable {
  final int levelIndex;
  final int shotCount;
  final int totalScore;
  final GameStatus status;

  const GameState({
    required this.levelIndex,
    required this.shotCount,
    required this.totalScore,
    required this.status,
  });

  factory GameState.initial() {
    return const GameState(
      levelIndex: 0,
      shotCount: 0,
      totalScore: 0,
      status: GameStatus.playing,
    );
  }

  GameState copyWith({
    int? levelIndex,
    int? shotCount,
    int? totalScore,
    GameStatus? status,
  }) {
    return GameState(
      levelIndex: levelIndex ?? this.levelIndex,
      shotCount: shotCount ?? this.shotCount,
      totalScore: totalScore ?? this.totalScore,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [levelIndex, shotCount, totalScore, status];
}
