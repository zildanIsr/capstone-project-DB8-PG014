import 'package:finmene/models/user.dart';
import 'package:finmene/services/firebase_auth_service.dart';
import 'package:finmene/utils/enums/firabase_auth_enum.dart';
import 'package:flutter/material.dart';

class FirabaseAuthProvider extends ChangeNotifier {
  final FirebaseAuthService _service;

  FirabaseAuthProvider(this._service);

  String? _message;
  UserModel? _profile;
  FirebaseAuthStatus _authStatus = FirebaseAuthStatus.unauthenticated;

  UserModel? get profile => _profile;
  String? get message => _message;
  FirebaseAuthStatus get authStatus => _authStatus;

  Future createAccount(String email, String password) async {
    try {
      _authStatus = FirebaseAuthStatus.creatingAccount;
      notifyListeners();

      await _service.createUser(email, password);

      _authStatus = FirebaseAuthStatus.accountCreated;
      _message = "Create account is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }

  Future signInUser(String email, String password) async {
    try {
      _authStatus = FirebaseAuthStatus.authenticating;
      notifyListeners();

      final result = await _service.signInUser(email, password);

      _profile = UserModel(
        uuid: result.user?.uid ?? "",
        name: result.user?.displayName ?? email.split('@').first,
        email: result.user?.email ?? email,
        photoUrl: result.user?.photoURL,
      );

      _authStatus = FirebaseAuthStatus.authenticated;
      _message = "Sign in is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }

  Future signOutUser() async {
    try {
      _authStatus = FirebaseAuthStatus.signingOut;
      notifyListeners();

      await _service.signOut();

      _authStatus = FirebaseAuthStatus.unauthenticated;
      _message = "Sign out is success";
    } catch (e) {
      _message = e.toString();
      _authStatus = FirebaseAuthStatus.error;
    }
    notifyListeners();
  }

  Future updateProfile() async {
    final user = await _service.userChanges();
    _profile = UserModel(
      uuid: user?.uid ?? _profile!.uuid,
      name: user?.displayName ?? _profile!.name,
      email: user?.email ?? _profile!.email,
      photoUrl: user?.photoURL,
    );
    notifyListeners();
  }
}
