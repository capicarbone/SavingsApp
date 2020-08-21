import 'package:flutter/material.dart';

class NestedTab extends StatelessWidget {
  String text;
  bool isSelected = false;

  NestedTab({this.text, this.isSelected: false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              text.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.blueGrey),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (isSelected)
          Container(
            height: 2,
            width: double.infinity,
            color: Theme.of(context).primaryColor,
          )
      ],
    );
  }
}
