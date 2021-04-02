
import 'package:flutter/material.dart';

class CurrencyValue extends StatelessWidget {

  double value;
  bool asChange;

  CurrencyValue(this.value, [this.asChange = false]);

  String _getValueSymbol(){
    if (value < 0){
      return "-";
    }

    if (value > 0){
      return "+";
    }

    return "";
  }

  double get _absoluteValue => (value < 0) ? value*-1 : value;

  @override
  Widget build(BuildContext context) {
    return Text("${(asChange) ? _getValueSymbol() : "" } \$${_absoluteValue.toStringAsFixed(2)}", style: TextStyle(
      color: (value >= 0) ? Colors.green : Colors.red
    ), );
  }
}
