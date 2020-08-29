import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:savings_app/models/account_transfer_post.dart';
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


  Map<String, String> _getAuthenticatedHeader(){
    return {"Authorization": "Bearer $authToken"};
  }

  Future<http.Response> postTransaction(TransactionPost transactionData) async {
    Fund fund;

    var url = "https://flask-mymoney.herokuapp.com/api/transactions";
    var headers = _getAuthenticatedHeader();
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

    if (response.statusCode == 200) {
      Transaction transaction  = Transaction.fromMap(json.decode(response.body));
      _updateBalances(transaction);
    }

    // TODO: Save transactions in cache and database.

    print(response.body);

    return response;
  }

  Future<http.Response> postAccountTransfer(AccountTransferPost transferData) async {
    var url = "https://flask-mymoney.herokuapp.com/api/transaction/account-transfer";

    var body = {
      'description': transferData.description,
      'amount': transferData.amount.toString(),
      'to': transferData.accountToId,
      'from': transferData.accountFromId,
      'date_accomplished': DateFormat.yMd().format(transferData.dateAccomplished)
    };
    var headers = _getAuthenticatedHeader();

    var response = await http.post(url, body: body, headers: headers);

    Transaction transaction  = Transaction.fromMap(json.decode(response.body));

    _updateBalances(transaction);

    // TODO: Save transactions in cache and database.

    print(response.body);

    return response;
  }

  void _updateBalances(Transaction transaction){
    transaction.accountTransactions.forEach((element) {
      accountsRepository.updateBalance(element.accountId, element.change);
    });

    transaction.fundTransactions.forEach((element) {
      fundsRepository.updateBalance(element.fundId, element.change);
    });
  }
}
