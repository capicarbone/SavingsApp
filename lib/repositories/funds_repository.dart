import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:savings_app/app_settings.dart';
import 'package:savings_app/models/fund.dart';

class FundsRepository {
  String authToken;
  List<Fund> _funds = [];

  FundsRepository({this.authToken});

  // TODO: Remove, should not accesed directly.
  get funds => _funds;

  Future<List<Fund>> fetchUserFunds() async {

    var url = "${AppSettings.getAPIHost()}funds";

    final response = await http.get(
        url, headers: {"Authorization": "Bearer $authToken"});

    List<dynamic> objects = json.decode(response.body);

    _funds.clear();
    _funds.addAll(objects.map((map) => Fund.fromMap(map)));

    print("from /api/funds/ : " + response.body);

    return _funds;
  }

  Future<Fund> updateBalance(String fundId, double change) async {
    var fund = _funds.firstWhere((element) => element.id == fundId);

    // TODO: Update database.

    fund.balance += change;
    return fund;
  }

  Fund fundForCategory(String categoryId) {

    if (_funds.length == 0) {
      throw Exception("No cached funds");
    }

    return _funds.firstWhere((element) => element.categories.map((e) => e.id).contains(categoryId));


  }

  List<Fund> recoverUserFunds() {
    return _funds;
  }
}
