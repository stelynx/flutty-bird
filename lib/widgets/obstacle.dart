import 'package:flutter/material.dart';

import '../config/config.dart';

class Obstacle extends StatelessWidget {
  final Alignment alignment;
  final double height;

  const Obstacle._({@required this.alignment, @required this.height});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: alignment,
      duration: const Duration(milliseconds: 0),
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * Config.obstacleToScreenWidthRatio,
        height: height,
        color: Colors.red,
      ),
    );
  }
}

class UpperObstacle extends Obstacle {
  UpperObstacle({@required double positionX, @required double height})
      : super._(alignment: Alignment(positionX, -1), height: height);
}

class LowerObstacle extends Obstacle {
  LowerObstacle({@required double positionX, @required double height})
      : super._(alignment: Alignment(positionX, 1), height: height);
}
