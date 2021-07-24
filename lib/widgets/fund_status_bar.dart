
import 'package:flutter/material.dart';
import 'package:savings_app/models/fund.dart';

class FundStatusBar extends StatelessWidget {
  final Fund fund;
  const FundStatusBar({Key key, this.fund}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {

      final width = constraints.maxWidth;
      final height = 20.0;

      return Stack(
        children: [

          Container(
            width: width, height: height,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(12))
            ),
          ),
          Positioned(child: Container(
            width: width / 2, height: height,
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(12))
            ),
          ),),
          Positioned(child: Container(
            width: 6,
            height: height,
            color: Colors.blue,
          )
            ,top: 0, right: 0,),
        ],
      );
    });

  }
}
