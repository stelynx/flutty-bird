part of 'game_bloc.dart';

enum GameStatus {
  initial,
  playing,
  paused,
  gameOver,
}

@immutable
class GameState {
  /// Status of the game, either [initial], [playing], or [gameOver].
  final GameStatus status;

  /// Current score that is incremented every time a user passes an obstacle.
  final int score;

  final RankScore rankScore;

  /// Position of the bird in vertical direction.
  final double birdPositionY;

  /// Angle of the rotation of the bird.
  final double birdRotationAngle;

  /// Time since the last jump occured. Used for calculating the next [birdPositionY].
  final double timeSinceLastJump;

  /// Initial height of the bird when jump ocurred.
  /// Used for calculating the next [birdPositionY].
  final double birdPositionYAtJump;

  /// Ratio between [Config.deltaTime] and actual time used for calculations.
  final double gameSpeed;

  final List<double> obstaclePositionsX;

  final List<double> upperObstaclesHeight;

  final List<double> lowerObstaclesHeight;

  final bool refreshBannerAd;

  GameState({
    @required this.status,
    @required this.score,
    @required this.rankScore,
    @required this.birdPositionY,
    @required this.birdRotationAngle,
    @required this.timeSinceLastJump,
    @required this.birdPositionYAtJump,
    @required this.gameSpeed,
    @required this.obstaclePositionsX,
    @required this.upperObstaclesHeight,
    @required this.lowerObstaclesHeight,
    @required this.refreshBannerAd,
  });

  factory GameState.initial({
    @required RankScore rankScore,
  }) =>
      GameState(
        status: GameStatus.initial,
        score: 0,
        rankScore: rankScore,
        birdPositionY: 0,
        birdRotationAngle: 0,
        timeSinceLastJump: 0,
        birdPositionYAtJump: 0,
        gameSpeed: Config.initialGameSpeed,
        obstaclePositionsX: <double>[],
        upperObstaclesHeight: <double>[],
        lowerObstaclesHeight: <double>[],
        refreshBannerAd: true,
      );

  GameState copyWith({
    GameStatus status,
    int score,
    RankScore rankScore,
    double birdPositionY,
    double birdRotationAngle,
    double timeSinceLastJump,
    double birdPositionYAtJump,
    double gameSpeed,
    bool refreshBannerAd,
  }) =>
      GameState(
        status: status ?? this.status,
        score: score ?? this.score,
        rankScore: rankScore ?? this.rankScore,
        birdPositionY: birdPositionY ?? this.birdPositionY,
        birdRotationAngle: birdRotationAngle ?? this.birdRotationAngle,
        timeSinceLastJump: timeSinceLastJump ??
            this.timeSinceLastJump + (Config.deltaTime / 1000) * this.gameSpeed,
        birdPositionYAtJump: birdPositionYAtJump ?? this.birdPositionYAtJump,
        gameSpeed: gameSpeed ?? this.gameSpeed,
        obstaclePositionsX: this.obstaclePositionsX,
        upperObstaclesHeight: this.upperObstaclesHeight,
        lowerObstaclesHeight: this.lowerObstaclesHeight,
        refreshBannerAd: refreshBannerAd ?? false,
      );
}
