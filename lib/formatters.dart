
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

NumberFormat currencyFormat(BuildContext context, {int decimalDigits = 2}) {
  return NumberFormat.currency(
    name: '\$',
    decimalDigits: decimalDigits,
  );
}