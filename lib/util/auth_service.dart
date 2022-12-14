import 'package:flutter/material.dart';
import '/util/communication.dart';

class AuthService extends ChangeNotifier {
  bool _authenticated = Communication().amILoggedIn();

  bool get authenticated => _authenticated;

  set authenticated(bool value) {
    _authenticated = value;
    notifyListeners();
  }
}
