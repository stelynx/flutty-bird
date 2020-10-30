import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttybird/config/config.dart';

class GameControllerButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const GameControllerButton({
    @required this.icon,
    @required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Icon(
        icon,
        size: MediaQuery.of(context).size.height *
            Config.flexGround /
            Config.flexParts /
            3,
        color: enabled ? Colors.yellow[50] : Colors.white10,
      ),
    );
  }
}
