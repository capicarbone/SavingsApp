import 'package:flutter/material.dart';
import 'package:savings_app/models/fund.dart';

class _GoalMark extends StatelessWidget {
  final height;
  const _GoalMark({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: height,
      color: Colors.blue,
    );
  }
}


class FundStatusBar extends StatelessWidget {
  final Fund fund;
  final double balance;
  const FundStatusBar({Key key, this.fund, this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double currentGoal = 0;
      double previousGoal = 0;
      double nextGoal = 0;

      if (fund.minimumLimit != null && fund.maximumLimit != null) {
        if (balance < fund.minimumLimit) {
          currentGoal = fund.minimumLimit;
          nextGoal = fund.maximumLimit;
        }

        if (balance > fund.minimumLimit && balance < fund.maximumLimit) {
          currentGoal = fund.maximumLimit;
          previousGoal = fund.minimumLimit;
        }

        if (balance > fund.maximumLimit) {
          previousGoal = fund.maximumLimit;
          currentGoal = -1;
        }
      } else {
        if (fund.minimumLimit != null && balance < fund.minimumLimit) {
          currentGoal = fund.minimumLimit;
        }

        if (fund.maximumLimit != null && balance < fund.maximumLimit) {
          currentGoal = fund.maximumLimit;
        }
      }

      var currentToCurrentGoal =
          (currentGoal == -1) ? 1 : balance / currentGoal;

      final width = constraints.maxWidth;
      final proportionedWidth =
          width - width * 0.25 * ((previousGoal != 0) ? 2 : 1);
      final height = 20.0;

      return Stack(
        children: [
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
          Positioned(
            child: Container(
              width: proportionedWidth * currentToCurrentGoal +
                  ((previousGoal == 0) ? 0 : width * 0.25),
              height: height,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          if (previousGoal > 0)
            Positioned(
              child: _GoalMark(height: height,),
              top: 0,
              left: (currentGoal == -1)
                  ? proportionedWidth * (previousGoal / balance)
                  : width * 0.25,
            ),
          if (currentGoal > 0)
            Positioned(
              child: _GoalMark(height: height,),
              top: 0,
              right: width * 0.25,
            ),
          if (nextGoal > 0)
            Positioned(
              child: _GoalMark(height: height,),
              top: 0,
              right: width * 0.05,
            ),
          // TODO Show next goal mark
          // Add next goal mark
        ],
      );
    });
  }
}
