import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/admob_factory.dart';
import '../config/config.dart';
import '../config/flags.dart';
import '../logic/game_bloc.dart';
import '../widgets/bird.dart';
import '../widgets/game_controller_button.dart';
import '../widgets/game_label.dart';
import '../widgets/obstacle.dart';
import '../widgets/score.dart';

class MainScreen extends StatelessWidget {
  const MainScreen();

  List<Obstacle> _obstacleBuilder(
    BuildContext context,
    List<double> positionX,
    List<double> heightUpper,
    List<double> heightLower,
  ) {
    final List<Obstacle> obstacles = <Obstacle>[];

    for (int i = 0; i < positionX.length; i++) {
      obstacles
          .add(UpperObstacle(positionX: positionX[i], height: heightUpper[i]));
      obstacles
          .add(LowerObstacle(positionX: positionX[i], height: heightLower[i]));
    }

    return obstacles;
  }

  void _newGame() async {
    while (!(await RewardedVideoAd.instance.show())) {}
  }

  @override
  Widget build(BuildContext context) {
    if (Flags.enableRewardedAds) {
      RewardedVideoAd.instance.listener =
          (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
        if (event == RewardedVideoAdEvent.rewarded) {
          context.bloc<GameBloc>().newGame();
        }
      };

      RewardedVideoAd.instance.load(
        adUnitId: AdMobFactory.getRewardedAdUnitId(),
        targetingInfo: AdMobFactory.getTargetingInfo(),
      );
    }

    return GestureDetector(
      onTap: context.bloc<GameBloc>().jump,
      child: Scaffold(
        body: BlocBuilder<GameBloc, GameState>(
          builder: (BuildContext context, GameState state) {
            if (Flags.enableBannerAds && state.refreshBannerAd) {
              AdMobFactory.getBannerAd().show();
            }
            return Column(
              children: <Widget>[
                Expanded(
                  flex: Config.flexSky,
                  child: Stack(
                    children: <Widget>[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 0),
                        color: Colors.yellow[50],
                      ),
                      ..._obstacleBuilder(
                        context,
                        state.obstaclePositionsX,
                        state.upperObstaclesHeight,
                        state.lowerObstaclesHeight,
                      ),
                      Score(state.score.toString(),
                          gameStarted: state.status != GameStatus.initial),
                      Bird(
                        angle: state.birdRotationAngle,
                        positionY: state.birdPositionY,
                        isQueen: state.rankScore?.myRank == 1,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: Config.flexGround,
                  child: Container(
                    color: Colors.brown,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 50,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GameControllerButton(
                            icon: state.status == GameStatus.paused
                                ? CupertinoIcons.play_circle
                                : state.status == GameStatus.gameOver
                                    ? CupertinoIcons.add_circled
                                    : CupertinoIcons.pause_circle,
                            onTap: () {
                              if (state.status == GameStatus.playing)
                                context.bloc<GameBloc>().pause();
                              else if (state.status == GameStatus.paused)
                                context.bloc<GameBloc>().continueGame();
                              else if (state.status == GameStatus.gameOver) {
                                if (Flags.enableRewardedAds) {
                                  _newGame();
                                } else {
                                  context.bloc<GameBloc>().newGame();
                                }
                              }
                            },
                            enabled: state.status == GameStatus.playing ||
                                state.status == GameStatus.paused ||
                                state.status == GameStatus.gameOver,
                          ),
                          GameLabel(
                            title: 'My Best',
                            value: state.rankScore.myScore.toString(),
                          ),
                          GameLabel(
                            title: 'Global Best',
                            value:
                                state.rankScore.globalHeighestScore.toString(),
                          ),
                          GameLabel(
                            title: 'Rank',
                            value: state.rankScore.myRank.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
