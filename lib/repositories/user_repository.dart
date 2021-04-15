
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:savings_app/repositories/web_repository.dart';
import 'dart:convert';

class UserRepository extends WebRepository {

  Box get _box => Hive.box('user');

  Future<String> getAuthToken({
    @required String email,
    @required String password
  }) async{
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String credentialsEncoded = stringToBase64.encode("$email:$password");
    var url = "${getHost()}login";

    final response = await http.post(url,
        headers: {"Authorization": "Basic $credentialsEncoded"});

    if (response.statusCode == 200){
      final responseData = json.decode(response.body);

      return responseData['token'];
    }else{
      // TODO: Improve message
      throw Exception(response.body);
    }

  }

  Future<String> persistToken(String token) async {
    await _box.put("token", token);
    return token;
  }

  Future<String> removeToken() async{
    await _box.delete("token");

  }

  Future<bool> hasToken() async {
    return _box.containsKey("token");
  }

  String restoreToken() {
    return _box.get("token");
  }

}