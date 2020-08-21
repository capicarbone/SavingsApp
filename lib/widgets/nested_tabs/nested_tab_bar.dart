
import 'package:flutter/material.dart';
import 'package:savings_app/widgets/nested_tabs/tab.dart';

class NestedTabBar extends StatefulWidget {

  List<NestedTab> tabs;
  Function onTap;

  NestedTabBar({this.tabs, this.onTap});

  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar> {

  var selected = 0;

  Widget _buildTab(NestedTab tab) {
    var position = widget.tabs.indexOf(tab);

    return Expanded(
      child: InkWell(
        onTap: () {
          widget.onTap(position);
          setState(() {
            selected = position;
          });
        },
        child: NestedTab(text: tab.text, isSelected: position == selected,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    widget.tabs[selected].isSelected = true;
    return Column(
      children: <Widget>[
        Container(
          height: 72,
          child: Row(
            children: widget.tabs.map((e) => _buildTab(e)).toList(),
          ),
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: Color.fromARGB(200, 239, 239, 239),
        ),
      ],
    );
  }
}
