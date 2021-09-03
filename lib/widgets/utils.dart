

import 'package:flutter/material.dart';

const cardDecoration = const BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.all(Radius.circular(16)),
    boxShadow: [
      BoxShadow( offset: Offset(0, 0), blurRadius: 8,color: Color.fromARGB(40, 0, 0, 0), )
    ]
);

class CardDivider extends StatelessWidget {
  const CardDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(width: double.infinity, height: 2,
      color: Theme.of(context).colorScheme.surface,);
  }
}