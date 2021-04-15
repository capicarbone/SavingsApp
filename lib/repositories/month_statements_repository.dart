import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:savings_app/models/period_statement.dart';
import 'package:savings_app/repositories/web_repository.dart';

class MonthStatementsRepository extends WebRepository {
  MonthStatementsRepository({String authToken}) : super(authToken: authToken);

  static const resourceUri = "reports/month_statements";

  String get _resourceUrl => getHost() + resourceUri;

  // TODO: add month and year as parameters
  Future<List<PeriodStatement>> fetch([int page = 0]) async {

    var url = "$_resourceUrl?page=$page";

    final response =
        await http.get(url, headers: getAuthenticatedHeader(), );

    if (response.statusCode == 200) {
      LinkedHashMap<String, dynamic> parsedResponse =
          json.decode(response.body);

      List<PeriodStatement> statements = (parsedResponse['_items'] as List<dynamic>)
          .map((e) => PeriodStatement.fromMap(e))
          .toList();

      return statements;
    } else {
      throw Exception(response.body);
    }
  }
}
