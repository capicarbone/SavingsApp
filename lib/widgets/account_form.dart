
import 'package:flutter/material.dart';

class AccountForm extends StatelessWidget {

  String authToken;

  AccountForm({this.authToken});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("New account".toUpperCase(),
          style: TextStyle(color: Theme.of(context).primaryColor),),
          TextFormField(
            decoration: const InputDecoration(hintText: "Name"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("Save"),
                  onPressed: () {})
            ],
          )
        ],
      ),
    );
  }
}
