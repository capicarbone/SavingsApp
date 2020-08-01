
import 'package:http/http.dart' as http;

class TransactionsRepository {
  String authToken;

  TransactionsRepository({this.authToken});

  Future<String> postTransaction(double change, String accountId,
      String categoryId, DateTime accomplishedAt, String description) async{

      var url = "https://flask-mymoney.herokuapp.com/api/transactions";
      var headers = {"Authorization": "Bearer $authToken"};
      var body = {
        "description": description,
        "change": change.toString(),
        "account_id": accountId,
        "date_accomplished": "2020-02-21",
        "category": categoryId
      };
      var response = await http.post(url, body: body, headers: headers );

      print(response.body);

      return response.body;
  }
}