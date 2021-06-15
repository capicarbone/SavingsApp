
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savings_app/models/transaction.dart';

class TransactionTile extends StatelessWidget {


  Transaction transaction;
  DateTime date;
  String title;
  String description;
  double change;
  Function onTap;

  TransactionTile({this.transaction, this.title, this.description, this.date, this.change, this.onTap});

  Widget _buildTileDate(DateTime date){
    return Column(
      children: <Widget>[
        Text(date.day.toString(), style: TextStyle(fontSize: 18),),
        Text(DateFormat.MMM().format(date).toUpperCase()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        onTap(transaction);
      },
      leading: (date != null) ? _buildTileDate(date) : null,
      title: Text(title),
      subtitle: (description != null) ? Text(description) : null,
      trailing: Text(
        "\$${change}",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: (change) < 0
                ? Colors.red
                : Colors.green),
      ),
    );
  }
}
