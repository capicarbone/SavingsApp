
import 'package:meta/meta.dart';

class AccountTransaction{
  final String accountId;
  final double change;

  AccountTransaction({@required this.accountId, @required this.change});

  factory AccountTransaction.fromMap(Map<String, dynamic> map) {
    return AccountTransaction(
        accountId: map['fund'],
        change: map['change']
    );
  }
}

class FundTransaction{
  final String fundId;
  final double change;

  FundTransaction({@required this.fundId, @required this.change});

  factory FundTransaction.fromMap(Map<String, dynamic> map) {
    return FundTransaction(
      fundId: map['fund'],
      change: map['change']
    );
  }
}

class Transaction {
  final String id;
  final String description;
  final String categoryId;
  final String dateAccomplished;
  final List<AccountTransaction> accountTransactions = [];
  final List<FundTransaction> fundTransactions = [];


  Transaction({this.id, this.description, this.categoryId, this.dateAccomplished});

  factory Transaction.fromMap(Map<String, dynamic> map){

   var transaction = Transaction(
     id: map['id'],
     description: map['description'],
     dateAccomplished: map['date_accomplished'],
     categoryId: map['category']
   );

   List<dynamic> fund_trasactions = map['fund_transactions'];
   List<dynamic> account_transactions = map['account_transactions'];

   transaction.fundTransactions.addAll(
      fund_trasactions.map((e) => FundTransaction.fromMap(e))
   );

   transaction.accountTransactions.addAll(
     account_transactions.map((e) => AccountTransaction.fromMap(e))
   );

   return transaction;
  }
}