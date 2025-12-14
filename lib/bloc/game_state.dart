part of 'game_bloc.dart';

enum GameStatus { playing, won, lost }

class GameState extends Equatable {
  final int levelIndex;
  final int shotCount;
  final int totalScore;
  final GameStatus status;
  final int autoPlayCount;

  const GameState({
    required this.levelIndex,
    required this.shotCount,
    required this.totalScore,
    required this.status,
    required this.autoPlayCount,
  });

  factory GameState.initial() {
    return const GameState(
      levelIndex: 0,
      shotCount: 0,
      totalScore: 0,
      status: GameStatus.playing,
      autoPlayCount: 3,
    );
  }

  GameState copyWith({
    int? levelIndex,
    int? shotCount,
    int? totalScore,
    GameStatus? status,
    int? autoPlayCount,
  }) {
    return GameState(
      levelIndex: levelIndex ?? this.levelIndex,
      shotCount: shotCount ?? this.shotCount,
      totalScore: totalScore ?? this.totalScore,
      status: status ?? this.status,
      autoPlayCount: autoPlayCount ?? this.autoPlayCount,
    );
  }

  @override
  List<Object> get props => [levelIndex, shotCount, totalScore, status, autoPlayCount];
}
