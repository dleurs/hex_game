// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:hex_game/utils/keys_name.dart';
import 'package:test/test.dart';

void main() {
  group('Hex Game', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final baseScreenButtonPlayers = find.byValueKey(KeysName.BASE_SCREEN_BUTTON_GOTO_PLAYERS);
    final homeScreenTitle = find.byValueKey(KeysName.HOME_SCREEN_TITLE);
    final playersScreenTitle = find.byValueKey(KeysName.PLAYERS_SCREEN_TITLE);

    late FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Home screen', () async {
      expect(await driver.getText(homeScreenTitle), "Hex game");
    });

    test('Go to players', () async {
      // First, tap the button.
      await driver.tap(baseScreenButtonPlayers);

      expect(await driver.getText(playersScreenTitle), "Players");
    });
  });
}
