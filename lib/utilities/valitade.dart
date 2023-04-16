class Validate {
  static String? Function(String?)? get email {
    return (value) {
      const Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      final regex = RegExp(pattern.toString());
      if ((value ?? '').isEmpty) {
        return ValidateStrings.emailrequired;
      } else if (!regex.hasMatch(value ?? '')) {
        return ValidateStrings.emailBadFormat;
      } else {
        return null;
      }
    };
  }
}

class ValidateStrings {
  static const String emailrequired = 'E-posta girmek zorunludur.';
  static const String emailBadFormat = 'Gerçeli bir email girin.';
}
