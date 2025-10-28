import 'package:finmene/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserLocal? _user;

  UserLocal? get user => _user;

  set user(UserLocal? user) {
    if (_user != user) {
      _user = user;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }

  void initUser(UserLocal? user) {
    if (_user != user) {
      _user = user;
    }
  }
}