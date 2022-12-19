import 'package:flutter/material.dart';
import '/util/communication.dart';

class AuthService extends ChangeNotifier {
  bool _isAdmin = false;
  bool _authenticated = false;
  bool get authenticated => _authenticated;
  bool get isAdmin => _isAdmin;

  set authenticated(bool value) {
    _authenticated = value;
    notifyListeners();
  }
  set isAdmin(bool value) {
    _isAdmin = value;
    notifyListeners();
  }
}
