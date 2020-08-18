
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:savings_app/models/account.dart';

class AccountsRepository {
  String authToken;
  List<Account> _accounts = [];

  AccountsRepository({this.authToken});

  // TODO: Remove
  get accounts => _accounts;

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

  Future<Account> updateBalance(String accountId, double change) async{
    var account = _accounts.firstWhere((element) => element.id == accountId);

    // TODO: update database

    account.balance += change;

    return account;
  }

  Account getAccountById(String accountId) {
    if (_accounts.length > 0) {
      return _accounts.firstWhere((element) => element.id == accountId);
    }else{
      throw Exception("Accounts not loaded yet");
    }
  }
}