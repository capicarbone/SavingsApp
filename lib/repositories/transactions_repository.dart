import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:savings_app/app_settings.dart';
import 'package:savings_app/models/account_transfer_post.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/models/category.dart' as transactionCategory;
import 'package:savings_app/models/transaction.dart';
import 'package:savings_app/models/transaction_post.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/categories_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';

class TransactionsRepository {
  String authToken;
  FundsRepository fundsRepository;
  AccountsRepository accountsRepository;
  CategoriesRepository categoriesRepository;

  TransactionsRepository(
      {@required this.authToken,
      @required this.fundsRepository,
      @required this.accountsRepository,
      @required this.categoriesRepository});

  Map<String, String> _getAuthenticatedHeader() {
    return {"Authorization": "Bearer $authToken"};
  }

  Future<http.Response> postTransaction(TransactionPost transactionData) async {

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
      body["category"] = transactionData.categoryId;
    }

    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      Transaction transaction = Transaction.fromMap(json.decode(response.body));
      _updateBalances(transaction);
    }

    // TODO: Save transactions in cache and database.

    print(response.body);

    return response;
  }

  Future<http.Response> postAccountTransfer(
      AccountTransferPost transferData) async {
    var url =
        "https://flask-mymoney.herokuapp.com/api/transaction/account-transfer";

    var body = {
      'description': transferData.description,
      'amount': transferData.amount.toString(),
      'to': transferData.accountToId,
      'from': transferData.accountFromId,
      'date_accomplished':
          DateFormat.yMd().format(transferData.dateAccomplished)
    };
    var headers = _getAuthenticatedHeader();

    var response = await http.post(url, body: body, headers: headers);

    Transaction transaction = Transaction.fromMap(json.decode(response.body));

    _updateBalances(transaction);

    // TODO: Save transactions in cache and database.

    print(response.body);

    return response;
  }

  /**
   * Send delete request for a transaction entity.
   */
  Future<bool> deleteTransaction(String accountId, String transactionId) async{
    var url = "${AppSettings.getAPIHost()}transaction/$transactionId";

    // TODO: Save delete action in database

    print(url);
    var response = await http.delete(url, headers: _getAuthenticatedHeader());

    print(response.body);

    if (response.statusCode == 204) {
      return true;
    }else {
      throw Exception(response.body);
    }
  }

  Future<List<Transaction>> fetchTransactions(
      String accountId, String fundId, {int pageSize:100}) async {
    var url = "https://flask-mymoney.herokuapp.com/api/transactions?page_size=$pageSize";

    if (accountId != null) {
      url += "&account_id=$accountId";
    }

    if (fundId != null) {
      url += "&fund_id=$fundId";
    }

    var header = _getAuthenticatedHeader();

    var response = await http.get(url, headers: header);

    var funds = await fundsRepository.fetchUserFunds();
    var accounts = await accountsRepository.fetchUserAccounts();
    var categories = await categoriesRepository.fetchCategories();

    print(response.body);

    if (response.statusCode == 200) {
      var jsonMap = json.decode(response.body) as List<dynamic>;

      var transactions = jsonMap
          .map((e) => Transaction.fromMap(e, categories, accounts, funds))
          .toList();

      transactions.sort((left, right) =>
          right.dateAccomplished.millisecondsSinceEpoch -
              left.dateAccomplished.millisecondsSinceEpoch);

      return transactions;
    } else {
      throw Exception("Error on request: " + response.statusCode.toString());
    }
  }

  Future<List<Transaction>> fetchFundTransactions(String fundId) async {
    return await fetchTransactions(null, fundId);
  }

  Future<List<Transaction>> fetchAccountTransactions(String accountId) async {
    return await fetchTransactions(accountId, null);
  }



  void _updateBalances(Transaction transaction) {
    transaction.accountTransactions.forEach((element) {
      accountsRepository.updateBalance(element.accountId, element.change);
    });

    transaction.fundTransactions.forEach((element) {
      fundsRepository.updateBalance(element.fundId, element.change);
    });
  }
}
