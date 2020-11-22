
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {

  Box get box => Hive.box('user');

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
    await box.put("token", token);
  }

  Future<String> removeToken() async{
    await box.delete("token");

  }

  Future<bool> hasToken() async {
    return box.containsKey("token");
  }

  Future<String> restoreToken() async {
    return await box.get("token");
  }

}