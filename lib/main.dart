import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/admob_factory.dart';
import 'config/config.dart';
import 'logic/game_bloc.dart';
import 'models/rank_score.dart';
import 'screens/main_screen.dart';
import 'services/firestore_service.dart';

SharedPreferences _sharedPreferences;
RankScore _rankScore;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _sharedPreferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp();
  _rankScore = await FirestoreService.getRankAndScore(
      _sharedPreferences.getString(Config.sharedPreferencesIdKey));

  await FirebaseAdMob.instance.initialize(appId: AdMobFactory.getAppId());

  runApp(FluttyBirdApp());
}

class FluttyBirdApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Flutty Bird',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  const _Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameBloc>(
      create: (_) => GameBloc(
        screenHeight: MediaQuery.of(context).size.height,
        sharedPreferences: _sharedPreferences,
        globalRankScore: _rankScore,
      ),
      child: MainScreen(),
    );
  }
}
