import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/transaction_post.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';

class TransactionsRepository {
  String authToken;
  FundsRepository fundsRepository;
  AccountsRepository accountsRepository;

  TransactionsRepository(
      {@required this.authToken,
      @required this.fundsRepository,
      @required this.accountsRepository});

  Future<http.Response> postTransaction(TransactionPost transactionData) async {
    Fund fund;

    var url = "https://flask-mymoney.herokuapp.com/api/transactions";
    var headers = {"Authorization": "Bearer $authToken"};
    var body = {
      "description": transactionData.description,
      "change": transactionData.amount.toString(),
      "account_id": transactionData.accountId,
      "date_accomplished":
          DateFormat.yMd().format(transactionData.accomplishedAt)
    };

    if (transactionData.categoryId != null) {
      // TODO: When categories for incomes introduced, a category must be required.
      body["category"] = transactionData.categoryId;
      fund = fundsRepository.fundForCategory(transactionData.categoryId);
    }
    var response = await http.post(url, body: body, headers: headers);

    Transaction transaction  = Transaction.fromMap(json.decode(response.body));

    // Updating cached account balance

    accountsRepository.updateBalance(
        transactionData.accountId, transactionData.amount);

    // Updating cached fund balance.

    if (fund != null) {
      fundsRepository.updateBalance(fund.id, transactionData.amount);
    }

    print(response.body);

    return response;
  }
}
