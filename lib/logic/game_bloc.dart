import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/config.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final double screenHeight;
  final double skyHeight;
  final Random random;
  final SharedPreferences sharedPreferences;

  Timer timer;

  GameBloc({
    @required this.screenHeight,
    @required this.sharedPreferences,
  })  : skyHeight = screenHeight / Config.flexParts * Config.flexSky,
        random = Random(),
        super(GameState.initial(
          sharedPreferences.getInt(Config.sharedPreferencesScoreKey) ?? 0,
        ));

  void jump() {
    if (state.status == GameStatus.playing) {
      this.add(JumpEvent());
    } else if (state.status == GameStatus.initial) {
      this.add(StartEvent(true));
    }
  }

  void newGame() => this.add(InitializeEvent());
  void pause() => this.add(PauseEvent());
  void continueGame() => this.add(StartEvent(false));

  Timer _newTimer() {
    return Timer.periodic(
      const Duration(milliseconds: Config.deltaTime),
      (Timer timer) {
        final double deltaHeight =
            (Config.gravityAccelerationHalved * state.timeSinceLastJump +
                    Config.jumpSpeed) *
                state.timeSinceLastJump;
        this.add(UpdateScreenEvent(deltaHeight: deltaHeight));
      },
    );
  }

  double _getNewUpperObstacleHeight() {
    return skyHeight *
            (1 -
                2 * Config.minimumObstacleHeightToSky -
                Config.obstacleSpaceToSky) *
            random.nextDouble() +
        skyHeight * Config.minimumObstacleHeightToSky;
  }

  double _getNewLowerObstacleHeight({@required double upperHeight}) {
    return skyHeight * (1 - Config.obstacleSpaceToSky) - upperHeight;
  }

  @override
  Stream<GameState> mapEventToState(
    GameEvent event,
  ) async* {
    if (event is InitializeEvent) {
      yield GameState.initial(state.heighestScore);
    } else if (event is JumpEvent) {
      yield state.copyWith(
        timeSinceLastJump: 0,
        birdPositionYAtJump: state.birdPositionY,
      );
    } else if (event is PauseEvent) {
      timer.cancel();
      yield state.copyWith(status: GameStatus.paused);
    } else if (event is StartEvent) {
      if (event.eraseState) yield GameState.initial(state.heighestScore);
      timer = _newTimer();
    } else if (event is UpdateScreenEvent) {
      // Check collision
      if (state.birdPositionY > 1 || state.birdPositionY < -1) {
        timer.cancel();
        if (state.score > state.heighestScore) {
          sharedPreferences.setInt(
              Config.sharedPreferencesScoreKey, state.score);
        }
        yield state.copyWith(
          status: GameStatus.gameOver,
          heighestScore: state.score > state.heighestScore ? state.score : null,
        );
        return;
      }

      final double birdDistanceFromTop =
          (state.birdPositionY + 1) / 2 * skyHeight;
      final double birdDistanceFromBottom = skyHeight - (birdDistanceFromTop);

      bool collided = false;
      for (int i = 0; i < state.obstaclePositionsX.length; i++) {
        if ((state.obstaclePositionsX[i] -
                    Config.birdPositionX -
                    Config.obstacleToScreenWidthRatio / 2)
                .abs() >
            Config.obstacleToScreenWidthRatio) continue;

        if (birdDistanceFromTop < state.upperObstaclesHeight[i] ||
            birdDistanceFromBottom < state.lowerObstaclesHeight[i]) {
          collided = true;
          break;
        }
      }

      if (collided) {
        timer.cancel();
        if (state.score > state.heighestScore) {
          sharedPreferences.setInt(
              Config.sharedPreferencesScoreKey, state.score);
        }
        yield state.copyWith(
          status: GameStatus.gameOver,
          heighestScore: state.score > state.heighestScore ? state.score : null,
        );
        return;
      }

      // Bird
      final double nextBirdPositionY =
          state.birdPositionYAtJump + event.deltaHeight;
      final double angle = atan(
          500 / Config.deltaTime * (nextBirdPositionY - state.birdPositionY));

      // Obstacles
      bool increaseScore = false;
      if (state.status != GameStatus.initial) {
        if (state.obstaclePositionsX[0] < -1.5) {
          state.obstaclePositionsX.removeAt(0);
          state.upperObstaclesHeight.removeAt(0);
          state.lowerObstaclesHeight.removeAt(0);

          state.obstaclePositionsX.add(
            state.obstaclePositionsX[Config.nObstacles - 2] +
                Config.obstacleDistance,
          );
          state.upperObstaclesHeight.add(_getNewUpperObstacleHeight());
          state.lowerObstaclesHeight.add(_getNewLowerObstacleHeight(
            upperHeight: state.upperObstaclesHeight[Config.nObstacles - 1],
          ));
        }
        for (int i = 0; i < Config.nObstacles; i++) {
          final double previousPositionX = state.obstaclePositionsX[i];

          state.obstaclePositionsX[i] +=
              Config.obstacleSpeed * Config.deltaTime / 1000 * state.gameSpeed;

          if (previousPositionX > Config.birdPositionX &&
              state.obstaclePositionsX[i] < Config.birdPositionX) {
            increaseScore = true;
          }
        }
      } else {
        for (int i = 0; i < Config.nObstacles; i++) {
          final double upperHeight = _getNewUpperObstacleHeight();
          state.obstaclePositionsX.add(1.5 + i * Config.obstacleDistance);
          state.upperObstaclesHeight.add(upperHeight);
          state.lowerObstaclesHeight
              .add(_getNewLowerObstacleHeight(upperHeight: upperHeight));
        }
      }

      double newSpeed = state.gameSpeed;
      if (increaseScore && state.score % Config.scoreToIncreaseSpeed == 0) {
        newSpeed *= Config.increaseSpeedRatio;
      }

      yield state.copyWith(
        birdPositionY: nextBirdPositionY,
        birdRotationAngle: angle,
        gameSpeed: newSpeed,
        score: state.score + (increaseScore ? 1 : 0),
        refreshBannerAd: increaseScore && state.score % 10 == 0,
      );
    }
  }
}
