
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:savings_app/models/transaction_post.dart';

class TransactionsRepository {
  String authToken;

  TransactionsRepository({this.authToken});

  Future<http.Response> postTransaction(TransactionPost transactionData) async{

      var url = "https://flask-mymoney.herokuapp.com/api/transactions";
      var headers = {"Authorization": "Bearer $authToken"};
      var body = {
        "description": transactionData.description,
        "change": transactionData.amount.toString(),
        "account_id": transactionData.accountId,
        "date_accomplished": DateFormat.yMd().format(transactionData.accomplishedAt)
      };

      if (transactionData.categoryId != null) {
        // TODO: When income category introduce, a category must be required.
        body["category"] =  transactionData.categoryId;
      }
      var response = await http.post(url, body: body, headers: headers );

      print(response.body);

      return response;
  }
}