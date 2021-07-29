import 'package:flutter/material.dart';
import 'package:savings_app/models/fund.dart';

enum _MarkDirection { right, left }

class _GoalMark extends StatelessWidget {

  final _MARK_WIDTH = 3.0;

  final height;
  final width;
  final _MarkDirection direction;
  const _GoalMark(
      {Key key, this.height, this.width, this.direction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    final mark = Container(
      width: _MARK_WIDTH,
      height: height * 1.4,
      color: Colors.blue,
    );

    final bar = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (direction == _MarkDirection.right)
        mark,
        Container(
          height: height,
          width: width - _MARK_WIDTH,
          decoration: BoxDecoration(
              color: Colors.white.withAlpha(80),
              borderRadius: BorderRadius.only(
                  topRight: (direction == _MarkDirection.right) ? Radius.circular(12) : Radius.zero,
                  bottomRight: (direction == _MarkDirection.right) ? Radius.circular(12) : Radius.zero,
              topLeft: (direction == _MarkDirection.left) ? Radius.circular(12) : Radius.zero,
              bottomLeft: (direction == _MarkDirection.left) ? Radius.circular(12) : Radius.zero)

          ),
        ),
        if (direction == _MarkDirection.left)
          mark
      ],
    );

    if (direction == _MarkDirection.right){
      return Positioned(
        child: bar,
        top: 0,
        right: 0,
      );
    }
    else{
      return Positioned(
        child: bar,
        top: 0,
        left: 0,
      );
    }
  }
}

class FundStatusBar extends StatelessWidget {
  final Fund fund;
  final double balance;
  const FundStatusBar({Key key, this.fund, this.balance}) : super(key: key);

  Color _getBarColor(){
    if ( fund.minimumLimit != null && balance < fund.minimumLimit){
      return Colors.red;
    }

    if ((fund.maximumLimit == null && fund.minimumLimit == null) || (fund.maximumLimit != null && balance >= fund.maximumLimit * 0.9)){
      return Colors.green;
    }

    return Colors.orange;
  }

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

        if (balance >= fund.minimumLimit && balance < fund.maximumLimit) {
          currentGoal = fund.maximumLimit;
          previousGoal = fund.minimumLimit;
        }

        if (balance >= fund.maximumLimit) {
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
      final barHeight = 20.0;

      return Container(
        width: width,
        height: barHeight * 1.4,
        child: Stack(
          children: [
            Container(
              width: width,
              height: barHeight,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
            Positioned(
              child: Container(
                width: proportionedWidth * currentToCurrentGoal +
                    ((previousGoal == 0) ? 0 : width * 0.25),
                height: barHeight,
                decoration: BoxDecoration(
                    color: _getBarColor(),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            if (previousGoal > 0)
              _GoalMark(
                direction: _MarkDirection.left,
                height: barHeight,
                width: (currentGoal == -1)
                    ? proportionedWidth * (previousGoal / balance)
                    : width * 0.10,
              ),
            if (currentGoal > 0)
              _GoalMark(
                direction: _MarkDirection.right,
                height: barHeight,
                width: width * 0.20,
              ),

            if (nextGoal > 0)
              _GoalMark(
                height: barHeight,
                width: width * 0.05,
                direction: _MarkDirection.right,

              ),
            // TODO Show next goal mark
            // Add next goal mark
          ],
        ),
      );
    });
  }
}
