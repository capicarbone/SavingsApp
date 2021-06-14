
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

    final response = await http.get("${getHost()}accounts",
      headers: getAuthenticatedHeader());

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

  Future<Account> post({String name, double initialBalance}) async {

    var headers = getAuthenticatedHeader();
    var body = {'name': name};
    var url  = "${getHost()}accounts";

    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200){
      var serverAccount = json.decode(response.body);
      var newAccount = Account(id: serverAccount['id'], name: serverAccount['name']);
      return newAccount;
    }else{
      throw Exception(response.body);
    }

  }

  Future<Account> save({String name, double initialBalance = 0.0}) async{

    var newAccount = await post(name: name, initialBalance: initialBalance);

    _box.put(newAccount.id, newAccount);

    return newAccount;
  }

  List<Account> restore() {
    return [ for (var element in _box.values ) Account.copy(element) ];
  }

  List<Account> restoreSorted() {
    return restore()..sort((a, b) => a.name.compareTo(b.name));
  }

  List<Account> sortedRestore() {
    return restore()..sort((a,b) => a.name.compareTo(b.name));
  }

  Future<Account> updateBalance(String accountId, double change) async{
    var account = _box.get(accountId);

    account.balance += change;


    await _box.put(account.id, account);

    return account;
  }

  Account restoreById(String id){
    return restore().firstWhere((element) => element.id == id, orElse: () => null);
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