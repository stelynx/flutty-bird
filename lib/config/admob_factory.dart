import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

abstract class AdMobFactory {
  static String getAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-6844643626556379~5419725363';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-6844643626556379~9096258257';
    }
    return '';
  }

  static String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-6844643626556379/1480480350';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-6844643626556379/3983037539';
    }

    return '';
  }

  static String getRewardedAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-6844643626556379/3013221747';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-6844643626556379/5036581987';
    }
    return '';
  }

  static BannerAd getBannerAd() {
    return BannerAd(
      adUnitId: AdMobFactory.getBannerAdUnitId(),
      targetingInfo: AdMobFactory.getTargetingInfo(),
      size: AdSize.smartBanner,
    )..load();
  }

  static MobileAdTargetingInfo getTargetingInfo() {
    return MobileAdTargetingInfo(nonPersonalizedAds: Platform.isIOS);
  }
}
