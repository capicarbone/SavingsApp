import 'package:flutter/material.dart';

class RoundTabs extends StatefulWidget {
  final List<String> tabs;
  final Function onTabSelected;

  const RoundTabs({Key key, this.tabs, this.onTabSelected})
      : super(key: key);

  @override
  _RoundTabsState createState() => _RoundTabsState();
}

class _RoundTabsState extends State<RoundTabs> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...widget.tabs.asMap().entries.map(
              (e) => ElevatedButton(
                  onPressed: () {
                    widget.onTabSelected(e.key);
                  },
                  child: Text(e.value)),
            )
      ],
    );
  }
}
