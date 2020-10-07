import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class AppStateProvider with ChangeNotifier {
  void auth({
    String email,
    String password,
    String userName,
    bool login,
    var responseData,
  }) async {
    final response =
        await http.post('http://192.168.1.7:1337/auth/local', body: {
      'identifier': email,
      'password': password,
    });
  }

  void register({
    String email,
    String password,
    String userName,
    var responseData,
  }) async {
    final response =
        await http.post('http://192.168.1.7:1337/auth/local/register', body: {
      'username': userName,
      'email': email,
      'password': password,
    });
  }

 Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var storedUser = prefs.getString('user');
     json.decode(storedUser);
    // print('Products:  ${json.decode(storedUser)} ');
   
  }
}
