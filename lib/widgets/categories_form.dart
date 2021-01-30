
import 'package:flutter/material.dart';
import 'package:savings_app/models/fund.dart';

class CategoriesForm extends StatefulWidget {

  String authToken;
  List<Fund> funds;

  CategoriesForm({this.authToken, this.funds});

  @override
  _CategoriesFormState createState() => _CategoriesFormState();
}

class _CategoriesFormState extends State<CategoriesForm> {
  final nameController = TextEditingController();

  bool isIncome = false;
  String categoryId = null;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New account".toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).primaryColor
             ),
            ),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Name"
              ),

            ),
            Row(
              children: [
                Checkbox(value: isIncome, onChanged: (value) {
                  setState(() {
                    isIncome = value;
                  });
                }),
                Text("Is income category")
              ],
            ),
            DropdownButtonFormField(
              //value: categoryId,
              decoration: const InputDecoration(hintText: "Fund"),
                items: [
              ...widget.funds.map((e) => DropdownMenuItem(child: Text(e.name), value: e.id,))
            ]
                , onChanged: (value) {
                categoryId = value;

            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              RaisedButton(
                  child: Text("Save"),
                  onPressed: () {})
            ],)

          ],
        ),
      ),
    );
  }
}
