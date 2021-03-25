class FormValidators {
  static const String PLAYER_PSEUDO = r'^([a-zA-Z0-9]{3,25})$';

  static bool isPlayerIdValid(String? value) {
    if (value == null) {
      return false;
    }
    return isPatternValid(PLAYER_PSEUDO, value);
  }

  static bool isPatternValid(String pattern, String input) {
    return RegExp(pattern).hasMatch(input);
  }
}
