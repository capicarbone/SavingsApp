
import 'package:flutter/material.dart';
import 'package:savings_app/models/account.dart';

class AccountTransactionsScreen extends StatelessWidget {

  static const routeName = '/transactions';

  @override
  Widget build(BuildContext context) {

    var args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    Account account = args['account'];

    return Scaffold(
      appBar: AppBar(title: Text(account.name),),
      body: Center(
        child: Text("Transactions"),
      ),
    );
  }
}
