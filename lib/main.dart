import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/admob_factory.dart';
import 'logic/game_bloc.dart';
import 'screens/main_screen.dart';

SharedPreferences _sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseAdMob.instance.initialize(appId: AdMobFactory.getAppId());

  _sharedPreferences = await SharedPreferences.getInstance();

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
      ),
      child: MainScreen(),
    );
  }
}
