// ignore_for_file: lines_longer_than_80_chars

class AppExceptions {
  static Exception get getUserDataException => Exception(
        'FirebaseAuth.instance.currentUser must be filled for to use the AuthService.getUserData function. FirebaseAuth.instance.currentUser is null',
      );
  static Exception get userDocumentIsNull => Exception(
        'User firestore document is null. non-existence',
      );
}
