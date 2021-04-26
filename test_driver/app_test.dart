// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Hex Game', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final baseScreenButtonPlayer = find.byValueKey('BaseScreenIconButtonGoToPlayer');
    final homeScreenTitle = find.byValueKey('HomeScreenTitle');
    final playerScreenNotConnectedTitle = find.byValueKey('PlayerScrenNotConnectedTitle');

    FlutterDriver driver;

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
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(homeScreenTitle), "Hex game");
    });

    test('Go to player', () async {
      // First, tap the button.
      await driver.tap(baseScreenButtonPlayer);

      // Then, verify the counter text is incremented by 1.
      expect(await driver.getText(playerScreenNotConnectedTitle), "Welcome");
    });
  });
}
