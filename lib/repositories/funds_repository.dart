import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:savings_app/app_settings.dart';
import 'package:savings_app/blocs/fund_form/fund_form_states.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/web_repository.dart';

class FundsRepository extends WebRepository{

  FundsRepository({String authToken}) : super(authToken: authToken);
  
  Box<Fund> get _box => Hive.box<Fund>('funds');

  Future<List<Fund>> sync() async {

    var url = "${getHost()}funds";

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

  Future<Fund> post(Fund fund) async {

    var url = "${getHost()}funds";
    var headers = getAuthenticatedHeader();

    var body = {
      'name': fund.name,
      'percentage_assignment': fund.percetageAssignment.toString(),
    };

    if (fund.description != null) {
      body['description'] = fund.description;
    }

    if (fund.maximumLimit != null){
      body['maximum_limit'] = fund.maximumLimit.toString();
    }

    if (fund.minimumLimit != null){
      body['minimum_limit'] = fund.minimumLimit.toString();
    }

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      var responseObj = jsonDecode(response.body);
      fund.id = responseObj['id'];
      return fund;
    }else{
      throw Exception(response.body);
    }

  }

  Future<Fund> save(Fund fund) async{

    var newFund = await post(fund);

    await _box.put(newFund.id, newFund);

    return  newFund;

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

  Fund get(String id) {
    return _box.get(id);
  }

  bool isLocallyEmpty() {
    return _box.isEmpty;
  }
}
