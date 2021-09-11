import 'package:flutter/material.dart';

class RoundTabs extends StatefulWidget {
  final List<String> tabs;
  final Function onTabSelected;
  final PageController pageController;

  const RoundTabs({Key key, this.tabs, this.onTabSelected, this.pageController})
      : super(key: key);

  @override
  _RoundTabsState createState() => _RoundTabsState();
}

class _RoundTabsState extends State<RoundTabs> {
  var selected = 0;
  Function _pageListener;

  @override
  void initState() {
    _pageListener = () {
      print("triggered");
      if (widget.pageController.page.round() != selected){
        setState(() {
          selected = widget.pageController.page.round();
        });
      }
    };
    widget.pageController.addListener(_pageListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_pageListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ...widget.tabs.asMap().entries.map(
              (e) => GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = e.key;
                    });
                    widget.onTabSelected(e.key);
                  },
                  child: Text(e.value,
                      style: TextStyle(
                        color: e.key == selected
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.primary,
                      ))),
            )
      ],
    );
  }
}
