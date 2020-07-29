import 'package:flutter/material.dart';

class InOutForm extends StatefulWidget {
  @override
  _InOutFormState createState() => _InOutFormState();
}

class _InOutFormState extends State<InOutForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
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
            decoration: const InputDecoration(
              hintText: "Category"
            ),
            items: [
              DropdownMenuItem(
                child: const Text("Option 1"),
                value: "Option 1",
              ),
              DropdownMenuItem(
                child: const Text("Option 2"),
                value: "Option 2"
              ),
              DropdownMenuItem(
                  child: const Text("Option 3"),
                  value: "Option 3"
              )
            ],
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

