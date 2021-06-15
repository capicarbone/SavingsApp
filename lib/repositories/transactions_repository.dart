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
import 'package:savings_app/repositories/web_repository.dart';

class TransactionsRepository extends WebRepository {
  String authToken;

  TransactionsRepository({@required this.authToken});

  Map<String, String> _getAuthenticatedHeader() {
    return {"Authorization": "Bearer $authToken"};
  }

  Future<Transaction> postTransaction(TransactionPost transactionData) async {
    var url = "${getHost()}transactions";
    var headers = _getAuthenticatedHeader();
    var body = {
      "description": transactionData.description,
      "change": transactionData.amount.toString(),
      "account_id": transactionData.accountId,
      "date_accomplished":
          DateFormat.yMd().add_Hms().format(transactionData.accomplishedAt)
    };

    if (transactionData.categoryId != null) {
      body["category"] = transactionData.categoryId;
    }

    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      Transaction transaction = Transaction.fromMap(json.decode(response.body));
      return transaction;
    } else {
      throw Exception(response.body);
    }
  }

  Future<Transaction> postAccountTransfer(
      AccountTransferPost transferData) async {
    var url = "${getHost()}transaction/account-transfer";

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

    return transaction;
  }

  /**
   * Send delete request for a transaction entity.
   */
  Future<bool> delete(String accountId, String transactionId) async {
    var url = "${getHost()}transaction/$transactionId";

    // TODO: Save delete action in database

    var response = await http.delete(url, headers: _getAuthenticatedHeader());

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception(response.body);
    }
  }

  Future<List<Transaction>> fetch(String accountId, String fundId,
      {int pageSize: 100}) async {
    var url = "${getHost()}transactions?page_size=$pageSize";

    if (accountId != null) {
      url += "&account_id=$accountId";
    }

    if (fundId != null) {
      url += "&fund_id=$fundId";
    }

    var header = _getAuthenticatedHeader();

    var response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      var jsonMap = json.decode(response.body) as List<dynamic>;

      var transactions = jsonMap.map((e) => Transaction.fromMap(e)).toList();

      transactions.sort((left, right) {
        var rightDate = right.dateAccomplished == null
            ? DateTime(0)
            : right.dateAccomplished;
        var leftDate =
            left.dateAccomplished == null ? DateTime(0) : left.dateAccomplished;

        return rightDate.millisecondsSinceEpoch -
            leftDate.millisecondsSinceEpoch;
      });

      return transactions;
    } else {
      throw Exception("Error on request: " + response.statusCode.toString());
    }
  }

  Future<List<Transaction>> fetchFundTransactions(String fundId) async {
    return await fetch(null, fundId);
  }

  Future<List<Transaction>> fetchAccountTransactions(String accountId) async {
    return await fetch(accountId, null);
  }
}
