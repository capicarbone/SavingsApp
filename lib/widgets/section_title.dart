
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 12, bottom: 12),
    child: Text(title, style: TextStyle(fontSize: 26,
    color: Theme.of(context).primaryColor),),);
  }
}
