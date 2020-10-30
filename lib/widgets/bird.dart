import 'package:flutter/material.dart';

import '../config/config.dart';

class Bird extends StatelessWidget {
  final double positionY;
  final double angle;

  const Bird({@required this.positionY, @required this.angle});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment(Config.birdPositionX, positionY),
      duration: const Duration(milliseconds: 0),
      color: Colors.transparent,
      child: Transform.rotate(
        angle: angle,
        child: Image.asset(
          'assets/images/bird.png',
          width: MediaQuery.of(context).size.height *
              Config.birdToScreenHeightRatio,
        ),
      ),
    );
  }
}
