import 'package:flutter/foundation.dart';

class RankScore {
  final String id;
  final int myScore;
  final int myRank;
  final int globalHeighestScore;

  const RankScore({
    @required this.id,
    @required this.myScore,
    @required this.myRank,
    @required this.globalHeighestScore,
  });
}
