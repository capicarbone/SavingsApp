
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {

  DateTime date;
  String title;
  String description;
  double change;

  TransactionTile({this.title, this.description, this.date, this.change});

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
      leading: _buildTileDate(date),
      title: Text(title),
      subtitle: Text(description),
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
