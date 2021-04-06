class FormValidators {
  static const String PSEUDO_PATTERN = r'^([a-zA-Z0-9]{3,25})$';
  static const String EMAIL_PATTERN =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
  static const String PASSWORD_PATTERN = r'^.{6,}$';

  static bool isPlayerIdValid(String? value) {
    if (value == null) {
      return false;
    }
    RegExp regex = new RegExp(FormValidators.PSEUDO_PATTERN);
    return (regex.hasMatch(value));
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    RegExp regex = new RegExp(FormValidators.EMAIL_PATTERN);
    if (!regex.hasMatch(value))
      return 'Please enter a valid email address.';
    else
      return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    RegExp regex = new RegExp(FormValidators.PASSWORD_PATTERN);
    if (!regex.hasMatch(value))
      return 'Password must be at least 6 characters.';
    else
      return null;
  }
}
