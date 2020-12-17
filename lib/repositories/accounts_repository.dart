
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/repositories/web_repository.dart';

class AccountsRepository extends WebRepository {

  AccountsRepository({String authToken}) : super(authToken: authToken);

  Box<Account> get _box => Hive.box<Account>('accounts');

  Future<List<Account>> sync() async {

    print("Bearer $authToken");

    final response = await http.get("https://flask-mymoney.herokuapp.com/api/accounts",
      headers: getAuthenticatedHeader());

    print (response.body);

    if (response.statusCode == 200) {
      List<dynamic> objects = json.decode(response.body);

      List<Account> accounts = [ for (var obj in objects) Account.fromMap(obj)];

      await _box.clear();
      _box.putAll( {for (var account in accounts ) account.id: account} );
      
      return accounts;
    } else {
      throw Exception(response.body);
    }

  }

  List<Account> restore() {
    return [ for (var element in _box.values ) element ];
  }

  Future<Account> updateBalance(String accountId, double change) async{
    var account = _box.get(accountId);

    account.balance += change;

    await _box.put(account.id, account);

    return account;
  }

  Account getAccountById(String accountId) {
    if (_box.isNotEmpty){
      return _box.get(accountId, defaultValue: null);
    }else{
      throw Exception("Accounts not loaded yet");
    }
  }

  bool isLocallyEmpty() {
    return _box.isEmpty;
  }
}