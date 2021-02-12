import 'package:flutter/material.dart';

class FundForm extends StatelessWidget {
  String authToken;

  FundForm({@required authToken});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Fund".toUpperCase(),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: "Name"),
          ),
          TextFormField(
            decoration: const InputDecoration(hintText: "Description"),
          ),
          TextFormField(
            decoration: const InputDecoration(
                hintText: "Assignment", suffix: Text("%")),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Minimum", suffix: Text("\$")),
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Limit", suffix: Text("\$")),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [RaisedButton(child: Text("Save"), onPressed: () {})],
          )
        ],
      ),
    );
  }
}
