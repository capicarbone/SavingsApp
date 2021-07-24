
import 'package:flutter/material.dart';
import 'package:savings_app/models/fund.dart';

class FundStatusBar extends StatelessWidget {
  final Fund fund;
  final double balance;
  const FundStatusBar({Key key, this.fund, this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {

      final width = constraints.maxWidth;
      final currentWith = width - width*0.25;
      final height = 20.0;

      double currentGoal = 0;
      double previousGoal = 0;
      double nextGoal = 0;

      if (fund.minimumLimit != null && fund.maximumLimit != null) {
        if (balance < fund.minimumLimit){
          currentGoal = fund.minimumLimit;
          nextGoal = fund.maximumLimit;
        }

        if (balance > fund.maximumLimit && balance < fund.minimumLimit){
          currentGoal = fund.maximumLimit;
          previousGoal = fund.minimumLimit;
        }

        if (balance > fund.maximumLimit) {
          previousGoal = fund.maximumLimit;
          currentGoal = -1;
        }
      }else{
        if (fund.minimumLimit != null && balance < fund.minimumLimit ){
          currentGoal = fund.minimumLimit;
        }

        if (fund.maximumLimit != null && balance < fund.maximumLimit ) {
          currentGoal = fund.maximumLimit;
        }
      }

      var currentToCurrentGoal = (currentGoal == -1) ? 1 : balance / currentGoal;

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
            width: currentWith*currentToCurrentGoal, height: height,
            decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(12))
            ),
          ),),
          if (previousGoal > 0)
            Positioned(child: Container(
              width: 6,
              height: height,
              color: Colors.blue,
            )
              ,top: 0, left: (currentGoal == -1) ? currentWith * (previousGoal / balance) : width * 0.25,),
          if (currentGoal > 0)
          Positioned(child: Container(
            width: 6,
            height: height,
            color: Colors.blue,
          )
            ,top: 0, right: width * 0.25,),
          // Add next goal mark
        ],
      );
    });

  }
}
