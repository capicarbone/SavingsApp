
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:savings_app/models/fund.dart';

class FundsRepository {
  String authToken;
  List<Fund> _funds = [];

  FundsRepository({this.authToken});

  Future<List<Fund>> fetchUserFunds() async {

    print("Bearer $authToken");

    final response = await http.get("https://flask-mymoney.herokuapp.com/api/funds",
        headers: {"Authorization": "Bearer $authToken"});

    List<dynamic> objects = json.decode(response.body);

    _funds.clear();
    _funds.addAll(objects.map((map) => Fund.fromMap(map) ));

    print (response.body);

    return _funds;

  }
}