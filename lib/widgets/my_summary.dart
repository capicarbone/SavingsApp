import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
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
  Widget _fundsSetionWidget(SummaryState state) {
    if (state is SummaryDataLoaded && state.funds != null) {
      return Container(
        child: Text("Funds loaded"),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget _accountsSetionWidget(SummaryState state) {
    if (state is SummaryDataLoaded && state.accounts != null) {
      return Container(
        child: Text("Accounts loaded"),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryBloc, SummaryState>(
      bloc: widget._summaryBloc,
      builder: (context, state) {
        return Container(
            child: Column(
          children: <Widget>[
            _fundsSetionWidget(state),
            _accountsSetionWidget(state)
          ],
        ));
      },
    );
  }

  @override
  void dispose() {
    //widget._summaryBloc.dispose();
    super.dispose();
  }
}
