
import 'package:flutter/material.dart';

class NewTransactionScreen extends StatefulWidget {

  static const routeName = '/new-transaction';

  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New transaction"),),
      body: Container(
        child: Center(child: Text("New Transaction form"),),
      ),
    );
  }
}
