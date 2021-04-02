
import 'package:flutter/material.dart';

class CurrencyValue extends StatelessWidget {

  double value;
  bool asChange;

  CurrencyValue(this.value, [this.asChange = false]);

  String get _valueSymbol{
    if (value < 0){
      return "-";
    }

    if (value > 0){
      return "+";
    }

    return "";
  }

  Color get _color {
    if (value > 0) {
      return Colors.green;
    }

    if (value < 0) {
      return Colors.red;
    }

    return Colors.black54;
  }

  double get _absoluteValue => (value < 0) ? value*-1 : value;

  @override
  Widget build(BuildContext context) {
    return Text("${(asChange) ? _valueSymbol : "" } \$${_absoluteValue.toStringAsFixed(2)}", style: TextStyle(
      color: _color
    ), );
  }
}
