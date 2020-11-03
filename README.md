![FluttyBird Logo](assets/git-banner.png)

# Flutty Bird

Addictive "Flappy bird" game implemented in Flutter with Flutter-inspired graphics.

<div style="height:10px"></div>

[![App Store](assets/download_on_the_app_store.svg)](https://apps.apple.com/app/id1537764935)
[![App Store](assets/get_it_on_google_play.png)](https://play.google.com/store/apps/details?id=com.stelynx.fluttybird)

## Rules

The rules are very simple. Tap the screen to jump and conquer gravity. Evade the obstacles coming your way and survive for as long as possible. Touching any of the obstacles or hitting the ceiling of floor, you die.

You can also pause the game while playing and come back later, as long as you do not close the app.

## Obstacle generation

Obstacles are generated so that distance between them is constant. The holes are always the same height, however their location is chosen completely randomly, but at least some distance away from top and bottom.

## Ranking

Compete with other players, completely anonymously! 🎉

When you first start a game, Firebase will generate you a unique ID, which your device will then
save to local storage using [`shared_preferences`](https://pub.dev/packages/shared_preferences) Flutter plugin, which uses `NSUserDefaults` on iOS and `SharedPreferences` on Android. When you will beat your score,
it will be automatically uploaded using your ID and saved in the cloud.

All one knows about other players is the global highest score and user's own rank, that's it. We know nothing personal about you, only your arbitrarily generated ID, that's it! Because we value privacy! 😇

Oh, we almost forgot! If you are on top of the ladder, your birdie gets a queen's crown! How cool is that?

## Application

![Screenshots](assets/screen.png)
