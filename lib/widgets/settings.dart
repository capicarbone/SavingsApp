
import 'package:flutter/material.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/widgets/category_form.dart';
import 'package:savings_app/widgets/fund_form.dart';

class Settings extends StatelessWidget {

  List<Fund> funds;
  String authToken;

  Settings({@required this.authToken, @required this.funds});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children:[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: CategoryForm(
                    authToken: authToken,
                    funds: funds,
                  ),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: FundForm(
                authToken: authToken,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

