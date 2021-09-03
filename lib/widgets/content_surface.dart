
import 'package:flutter/material.dart';

class ContentSurface extends StatelessWidget {
  final Widget child;
  const ContentSurface({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
      ),
      child: child,
    );
  }
}
