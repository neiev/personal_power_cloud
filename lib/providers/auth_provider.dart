import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';

class AuthProvider with ChangeNotifier {
  AuthClient? _authClient;
  String _email = '';
  String _password = '';
  String _host = '';
  String _port = '';
  String _user = '';
  String _password1 = '';

  AuthClient? get authClient => _authClient;
  String get email => _email;
  String get password => _password;
  String get host => _host;
  String get port => _port;
  String get user => _user;
  String get password1 => _password1;

  void setAuthClient(AuthClient client) {
    _authClient = client;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setHost(String host) {
    _host = host;
    notifyListeners();
  }

  void setPort(String port) {
    _port = port;
    notifyListeners();
  }

  void setUser(String user) {
    _user = user;
    notifyListeners();
  }

  void setPassword1(String password1) {
    _password1 = password1;
    notifyListeners();
  }
}