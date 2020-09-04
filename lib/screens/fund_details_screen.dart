
import 'package:flutter/material.dart';
import 'package:savings_app/models/fund.dart';

class FundDetailsScreen extends StatelessWidget {
  static const routeName = '/fund-details';

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    Fund fund = args['fund'];
    String authToken = args['authToken'];

    return Scaffold(
      appBar: AppBar(
        title: Text(fund.name),
      ),
      body: Column(children: <Widget>[
        Text("Fund details")
      ],),
    );
  }
}
