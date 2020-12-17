import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:savings_app/app_settings.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/web_repository.dart';

class FundsRepository extends WebRepository{

  FundsRepository({String authToken}) : super(authToken: authToken);
  
  Box<Fund> get _box => Hive.box<Fund>('funds');

  Future<List<Fund>> sync() async {

    var url = "${AppSettings.getAPIHost()}funds";

    final response = await http.get(
        url, headers: getAuthenticatedHeader());

    print("from /api/funds/ : " + response.body);

    if (response.statusCode == 200) {
      List<dynamic> objects = json.decode(response.body);
      List<Fund> funds = [ for (var obj in objects) Fund.fromMap(obj) ];

      await _box.clear();
      await _box.putAll( {for (var fund in funds) fund.id : fund } );

      return funds;

    } else {
      throw Exception(response.body);
    }


  }

  Future<Fund> updateBalance(String fundId, double change) async {
    var fund = _box.get(fundId);

    // TODO: Update database.

    fund.balance += change;
    return fund;
  }

  Fund fundForCategory(String categoryId) {

    if (_box.isEmpty) {
      throw Exception("No cached funds");
    }

    return this.restore().firstWhere((element) => element.categories.map((e) => e.id).contains(categoryId));


  }

  List<Fund> restore() {
    return _box.values.toList();
  }

  bool isLocallyEmpty() {
    return _box.isEmpty;
  }
}
