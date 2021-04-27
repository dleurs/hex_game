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
    final baseScreenButtonPlayer = find.byValueKey(KeysName.BASE_SCREEN_BUTTON_GOTO_PLAYER);
    final baseScreenButtonHome = find.byValueKey(KeysName.BASE_SCREEN_BUTTON_GOTO_HOME);

    final homeScreenTitle = find.byValueKey(KeysName.HOME_SCREEN_TITLE);

    final playersScreenTitle = find.byValueKey(KeysName.PLAYERS_SCREEN_TITLE);

    final playerScreenButtonLogout = find.byValueKey(KeysName.PLAYER_SCREEN_BUTTON_LOGOUT);

    final loginRegisterScreenTitle = find.byValueKey(KeysName.LOGIN_REGISTER_SCREEN_TITLE);
    final loginRegisterScreenTexFormFieldEmail = find.byValueKey(KeysName.LOGIN_REGISTER_SCREEN_TEXTFORMFIELD_EMAIL);
    final loginRegisterScreenTexFormFieldPseudo = find.byValueKey(KeysName.LOGIN_REGISTER_SCREEN_TEXTFORMFIELD_PSEUDO);
    final loginRegisterScreenTexFormFieldPassword =
        find.byValueKey(KeysName.LOGIN_REGISTER_SCREEN_TEXTFORMFIELD_PASSWORD);
    final loginRegisterScreenButtonCheckEmail = find.byValueKey(KeysName.LOGIN_REGISTER_SCREEN_BUTTON_CHECK_EMAIL_ONLY);
    final loginRegisterScreenButtonLoginEmailPassword =
        find.byValueKey(KeysName.LOGIN_REGISTER_SCREEN_BUTTON_EMAIL_PASSWORD);

    final playerScreenTitle = find.byValueKey(KeysName.PLAYER_SCREEN_TITLE);

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

    test('Step 1 : Cheking if in Home screen', () async {
      expect(await driver.getText(homeScreenTitle), "Hex game");
    });

    test('Step 2 : Loggout if logged', () async {
      // First, tap the button.
      await driver.tap(baseScreenButtonPlayer);
      // Can redirect to loginRegisterScreen or PlayerScreen if logged
      final isLogged = await isPresent(playerScreenTitle, driver);
      print("isLogged : " + isLogged.toString());
      if (isLogged) {
        await driver.tap(playerScreenButtonLogout);
      } else {
        await driver.tap(baseScreenButtonHome);
      }
      expect(await driver.getText(homeScreenTitle), "Hex game");
    });

    test('Step 3 : Go to Login Register Screen', () async {
      // First, tap the button.
      await driver.tap(baseScreenButtonPlayer);

      expect(await driver.getText(loginRegisterScreenTitle), "Welcome");
    });

    test('Step 4 : Create a user', () async {
      // First, tap the button.
      await driver.tap(baseScreenButtonPlayer);

      expect(await driver.getText(loginRegisterScreenTitle), "Welcome");
    });

    test('Step 5 : Enter email', () async {
      await driver.tap(loginRegisterScreenTexFormFieldEmail);
      await driver.enterText("wrongEmail");
      await driver.tap(loginRegisterScreenButtonCheckEmail);
      expect(await driver.getText(find.text("Please enter a valid email address.")),
          "Please enter a valid email address.");
    });
  });
}

isPresent(SerializableFinder byValueKey, FlutterDriver driver, {Duration timeout = const Duration(seconds: 1)}) async {
  try {
    await driver.waitFor(byValueKey, timeout: timeout);
    return true;
  } catch (exception) {
    return false;
  }
}
