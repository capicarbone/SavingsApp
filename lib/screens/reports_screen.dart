import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:savings_app/blocs/reports/reports_bloc.dart';
import 'package:savings_app/blocs/reports/reports_events.dart';
import 'package:savings_app/blocs/reports/reports_states.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_states.dart';
import 'package:savings_app/models/period_statement.dart';
import 'package:savings_app/screens/report_screen.dart';

class ReportsScreen extends StatelessWidget {

  const ReportsScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsBloc(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<SettingsSyncerBloc, SettingsSyncState>(
            listener: (context, state) {
              BlocProvider.of<ReportsBloc>(context).add(ReloadData());
            },
            listenWhen: (context, state) =>
                state is LocalDataUpdated || state is SettingsLoaded,
          ),
          BlocListener<ReportsBloc, ReportsState>(
            listener: (context, state) {
              // TODO: Notify error
            },
            listenWhen: (context, state) => state is PageLoadFailed,
          )
        ],
        child: BlocBuilder<ReportsBloc, ReportsState>(
          buildWhen: (context, state) {
            return !(state is PageLoadFailed);
          },
          builder: (context, state) {
            if (state is PageLoaded) {
              return _StatementsList(statements: state.monthStatements);
            }

            return _Loading();
          },
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
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

  String get _label {
    if (statement.isYear) {
      return statement.year.toString();
    }
    if (statement.isMonth){
      return DateFormat.MMMM().format(DateTime(1, statement.month));
    }
    if (statement.isGeneral){
      return "General";
    }

  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(ReportScreen.routeName,
          arguments: {'statement': statement}),
      child: Container(
        color: (statement.isYear) ? Colors.black12 : Colors.transparent,
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _label.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ValueLabel("Saving"),
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
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.red,
                    height: 4,
                  ),
                  flex: 100 - statement.savingsRatio.round(),
                ),
                Expanded(
                  child: Container(
                    color: Colors.green,
                    height: 4,
                  ),
                  flex: statement.savingsRatio.round(),
                ),
              ],
            )
          ],
        ),
      ),
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
