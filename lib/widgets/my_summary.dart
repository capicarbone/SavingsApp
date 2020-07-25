import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_states.dart';
import 'package:savings_app/blocs/summary/summary_bloc.dart';
import 'package:savings_app/blocs/summary/summary_events.dart';
import 'package:savings_app/blocs/summary/summary_states.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';

class MySummary extends StatefulWidget {
  // Maybe unnecesary
  String token;

  AccountsRepository accountsRepository;
  FundsRepository fundsRepository;
  final SummaryBloc _summaryBloc;

  MySummary(
      {@required this.token,
      @required this.fundsRepository,
      this.accountsRepository})
      : this._summaryBloc = SummaryBloc(
            accountsRepository: accountsRepository,
            fundsRepository: fundsRepository) {
    _summaryBloc.add(LoadDataEvent());
  }

  @override
  _MySummaryState createState() => _MySummaryState();
}

class _MySummaryState extends State<MySummary> {
  Widget _fundsSectionWidget(SummaryState state) {
    if (state is SummaryDataLoaded && state.funds != null) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Funds",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,
                  color: Theme.of(context).primaryColor),
            ),
            Column(
              children: state.funds
                  .map((e) => ListTile(
                title: Text(
                  e.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(e.balance.toString()),
              ))
                  .toList(),
            )
          ],
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget _accountsSectionWidget(SummaryState state) {
    if (state is SummaryDataLoaded && state.accounts != null) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Accounts",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Theme.of(context).primaryColor),
            ),
            Column(
              children: state.accounts
                  .map((e) => ListTile(
                        title: Text(
                          e.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(e.balance.toString()),
                      ))
                  .toList(),
            )
          ],
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsSyncerBloc, SettingsSyncState>(
      listenWhen: (previous, current) {
        return current is SettingsUpdated;
      },
      listener: (context, state) {
        // No estoy seguro si esto deberia estar aqui, quizas deberia estar despues
        // bloc builder
        widget._summaryBloc.add(LoadDataEvent());
      },
      child: BlocBuilder<SummaryBloc, SummaryState>(
        bloc: widget._summaryBloc,
        builder: (context, state) {
          return Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
            children: <Widget>[
                _fundsSectionWidget(state),
                _accountsSectionWidget(state)
            ],
          ),
              ));
        },
      ),
    );
  }

  @override
  void dispose() {
    //widget._summaryBloc.dispose();
    super.dispose();
  }
}
