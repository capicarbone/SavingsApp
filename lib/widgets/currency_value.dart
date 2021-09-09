import 'package:flutter/material.dart';
import 'package:savings_app/formatters.dart';

class CurrencyValue extends StatelessWidget {
  double value;
  bool asChange;
  TextStyle style;

  CurrencyValue(this.value, {this.asChange = false, this.style});

  String get _valueSymbol {
    if (value < 0) {
      return "-";
    }

    if (value > 0) {
      return asChange ? "+" : "";
    }

    return "";
  }

  Color get _color {

    if (asChange){
      if (value > 0) {
        return Colors.green;
      }

      if (value < 0) {
        return Colors.red;
      }
    }

    return Color(0xFF2B2B2B);
  }

  double get _absoluteValue => (value < 0) ? value * -1 : value;

  TextStyle get _baseTextStyle => TextStyle(color: _color);

  TextStyle get _textStyle {
    if (style != null) {
      return _baseTextStyle.merge(style);
    }

    return _baseTextStyle;
  }

  @override
  Widget build(BuildContext context) {

    return Text(
      "${_valueSymbol} ${currencyFormat(context).format(_absoluteValue)}",
      style: _textStyle.copyWith(color: asChange ? _color : Theme.of(context).textTheme.bodyText1.color),
      textAlign: TextAlign.right,
    );
  }
}
