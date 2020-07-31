import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';

class InOutForm extends StatefulWidget {
  List<Fund> funds;
  List<Account> accounts;
  List<Category> categories;

  InOutForm({@required this.funds, @required this.accounts}) {
    categories = [];

    funds.forEach((element) {
      categories.addAll(element.categories);
    });
  }

  @override
  _InOutFormState createState() => _InOutFormState();
}

class _InOutFormState extends State<InOutForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Amount",
            ),
          ),
          DropdownButtonFormField(
            onChanged: (s) {},
            decoration: const InputDecoration(hintText: "Category"),
            items: [
              ...widget.categories.map((e) => DropdownMenuItem(
                    child: Text(e.name),
                    value: e.id,
                  ))
            ],
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: "Description"),
          ),
          RaisedButton(
            child: Text("Save"),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
