import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:savings_app/blocs/reports/reports_bloc.dart';
import 'package:savings_app/blocs/reports/reports_events.dart';
import 'package:savings_app/blocs/reports/reports_states.dart';
import 'package:savings_app/models/period_statement.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsBloc(),
      child: BlocConsumer<ReportsBloc, ReportsState>(
        listener: (context, state) {},
        buildWhen: (context, state) {
          return !(state is PageLoadFailed);
        },
        builder: (context, state) {
          if (state is InitialState) {
            BlocProvider.of<ReportsBloc>(context).add(LoadNextPage());
            return Center(
              child: Text("starting"),
            );
          }

          if (state is PageLoaded) {
            return _StatementsList(statements: state.monthStatements);
          }
        },
      ),
    );
  }
}

class _StatementsList extends StatelessWidget {
  List<PeriodStatement> statements;

  _StatementsList({this.statements});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemBuilder: (context, index) {
        return _PeriodStatementItem(
          statement: statements[index],
        );
      },
      itemCount: statements.length,
    );
  }
}

class _PeriodStatementItem extends StatelessWidget {
  PeriodStatement statement;

  _PeriodStatementItem({this.statement});

  String get _label => (statement.isYear) ? statement.year.toString() : DateFormat.MMMM().format(DateTime(1, statement.month));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _label.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_ValueLabel("Income"), Text("\$${statement.totalIncome.toStringAsFixed(2)}")],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_ValueLabel("Expenses"), Text("\$${statement.totalExpense.toStringAsFixed(2)}")],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ValueLabel("Ahorro"),
                      Row(
                        children: [
                          Text(
                            statement.savingsRatio.round().toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          Text("%")
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 1,
          child: Container(
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}

class _ValueLabel extends StatelessWidget {
  String label;

  _ValueLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12),
    );
  }
}
