import 'package:flutter/material.dart';

class Score extends StatelessWidget {
  final String score;
  final bool gameStarted;

  const Score(this.score, {@required this.gameStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, -0.6),
      child: !gameStarted
          ? Text(
              'T A P   T O   S T A R T',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 40,
              ),
            )
          : Text(
              score,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 15,
                fontWeight: FontWeight.w100,
              ),
            ),
    );
  }
}
