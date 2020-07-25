
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:savings_app/models/account.dart';

class AccountsRepository {
  String authToken;
  List<Account> _accounts = [];

  AccountsRepository({this.authToken});

  Future<List<Account>> fetchUserAccounts() async {

    print("Bearer $authToken");

    final response = await http.get("https://flask-mymoney.herokuapp.com/api/accounts",
      headers: {"Authorization": "Bearer $authToken"});

    List<dynamic> objects = json.decode(response.body);

    _accounts.clear();
    _accounts.addAll(objects.map((map) => Account.fromMap(map)));

    print (response.body);

    return _accounts;

  }

  List<Account> recoverUserAccounts() {
    return _accounts;
  }
}