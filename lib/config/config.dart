abstract class Config {
  static const double birdToScreenHeightRatio = 0.05;

  static const double birdPositionX = -0.75;

  /// Screen should be refreshed every [deltaTime] milliseconds, so
  /// this is basically 1000ms/FPS.
  static const int deltaTime = 10;

  /// Initial ratio between [deltaTime] and time increment for position calculation.
  static const double initialGameSpeed = 0.8;

  static const int scoreToIncreaseSpeed = 20;

  static const double increaseSpeedRatio = 1.02;

  /// Vertical speed to be inforced when a jump occurs.
  /// The value is negative because upwards is negative in Alignment notation.
  static const double jumpSpeed = -1.8;

  /// Acceleration due to gravity. The value is positive because downwards
  /// is positive in Alignment notation.
  static const double gravityAccelerationHalved = 4.9;

  static const int nObstacles = 3;

  static const double obstacleDistance = 1.6;

  static const double minimumObstacleHeightToSky = 0.15;

  static const double obstacleToScreenWidthRatio = 1 / 8;

  static const double obstacleSpeed = -1.5;

  /// Vertical space between upper and lower obstacle, where a bird can move through,
  /// given as ratio with respect to sky.
  static const double obstacleSpaceToSky = 0.2;

  /// Flex weight for sky.
  static const int flexSky = 3;

  /// Flex weight for ground.
  static const int flexGround = 1;

  /// Total flex parts.
  static const int flexParts = flexSky + flexGround;

  static const String sharedPreferencesScoreKey = 'FLUTTYBIRD_SCORE';
}