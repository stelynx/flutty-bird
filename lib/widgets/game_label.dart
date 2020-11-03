import 'package:flutter/material.dart';

class GameLabel extends StatelessWidget {
  final String title;
  final String value;

  const GameLabel({
    @required this.title,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 60,
            color: Colors.yellow[50],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height / 20,
            fontWeight: FontWeight.w100,
            color: Colors.yellow[50],
          ),
        ),
      ],
    );
  }
}
