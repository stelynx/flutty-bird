import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/rank_score.dart';

const String _scoresCollection = 'scores';
const String _scoreKey = 'score';

abstract class FirestoreService {
  static Future<RankScore> getRankAndScore(String userId) async {
    if (userId == null) userId = await FirestoreService.updateScore(0);

    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(_scoresCollection).get();

    final List<int> scores = querySnapshot.docs
        .map<int>(
          (QueryDocumentSnapshot qds) => qds.data().values.toList()[0] as int,
        )
        .toList()
          ..sort();

    int myScore;
    try {
      myScore = querySnapshot.docs
          .where((QueryDocumentSnapshot qds) => qds.reference.id == userId)
          .toList()
          .first
          .get(_scoreKey);
    } on StateError catch (_) {
      return null;
    }

    return RankScore(
      id: userId,
      myScore: myScore,
      myRank: scores.length - scores.lastIndexOf(myScore),
      globalHeighestScore: scores.last,
    );
  }

  static Future<String> updateScore(int newScore, [String userId]) async {
    if (userId != null)
      await FirebaseFirestore.instance
          .collection(_scoresCollection)
          .doc(userId)
          .set({_scoreKey: newScore});
    else
      userId = (await FirebaseFirestore.instance
              .collection(_scoresCollection)
              .add({_scoreKey: newScore}))
          .id;

    return userId;
  }

  static Future<int> getScore(String userId) async {
    return (await FirebaseFirestore.instance
            .collection(_scoresCollection)
            .doc(userId)
            .get())
        .get(_scoreKey);
  }
}
