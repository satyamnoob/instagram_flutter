import 'package:flutter/material.dart';
import 'package:instagram_flutter/controller/auth_controller.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthController _authController = AuthController();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authController.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
