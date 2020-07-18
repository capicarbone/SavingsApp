
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {

  // From local storage
  Future<String> restoreAuthToken(){

    return null;
  }

  Future<String> getAuthToken({
    @required String email,
    @required String password
  }) async{
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String credentialsEncoded = stringToBase64.encode("$email:$password");

    final response = await http.post("https://flask-mymoney.herokuapp.com/api/login",
        headers: {"Authorization": "Basic $credentialsEncoded"});

    print(response.body);

    if (response.statusCode == 200){
      final responseData = json.decode(response.body);

      return responseData['token'];
    }else{
      // TODO: Improve message
      throw Exception(response.body);
    }

  }

  Future<String> persistToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  Future<String> removeToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  Future<bool> hastToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().contains("token");
  }

}