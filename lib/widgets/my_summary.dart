import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/screens/account_details_screen.dart';
import 'package:savings_app/screens/fund_details_screen.dart';
import 'package:savings_app/widgets/currency_value.dart';

class MySummaryScreen extends StatefulWidget {
  // Maybe unnecesary
  String token;

  MySummaryScreen(
      {@required this.token}) ;

  @override
  _MySummaryScreenState createState() => _MySummaryScreenState();
}

class _MySummaryScreenState extends State<MySummaryScreen> {

  void _refresh(BuildContext ctx){
    //TODO: I should update from the database and not from the server
    // so, calling the SummaryBloc it should be the right choice.
    BlocProvider.of<SettingsSyncerBloc>(ctx).add(SettingsSyncerSyncRequested());
  }
  Widget _fundsSectionWidget() {

      return BlocBuilder<SettingsSyncerBloc, SettingsSyncState>(
        buildWhen: (_, state) => state is DataContainerState && state.funds != null,
        builder: (context, state) {
          var funds = (state as DataContainerState).funds;
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Funds".toUpperCase(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor),
                ),
                Column(
                  children: funds
                      .map((e) => InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(FundDetailsScreen.routeName,
                          arguments: {'fund': e, 'authToken': widget.token});
                    },
                    child: ListTile(
                      title: Text(
                        e.name,
                      ),
                      subtitle: Text("Receiving ${(e.percetageAssignment*100).toStringAsFixed(0)}% of your income.", style: TextStyle(fontSize: 12),),

                      trailing: CurrencyValue(e.balance, style: TextStyle(fontSize: 16),),

                    ),
                  ))
                      .toList(),
                )
              ],
            ),
          );
        }
      );

  }

  Widget _accountsSectionWidget() {

    return BlocBuilder<SettingsSyncerBloc, SettingsSyncState>(
        builder: (context, state) {
      var accounts = (state as DataContainerState).accounts;
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Accounts".toUpperCase(),
              style: TextStyle(

                  color: Theme.of(context).primaryColor),
            ),
            Column(
              children: accounts
                  .map((e) => InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AccountDetailsScreen.routeName,
                      arguments: {'account': e, 'authToken': widget.token})
                      .then((_) {
                    _refresh(context);
                  });
                },
                child: ListTile(
                  title: Text(
                    e.name,
                  ),
                  trailing: CurrencyValue(e.balance, style: TextStyle(color: e.balance < 0 ? Colors.red : Colors.black, fontSize: 16),),
                ),
              ))
                  .toList(),
            )
          ],
        ),
      );
    });


  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

        child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 18,
                  ),
                  _fundsSectionWidget(),
                  SizedBox(height: 18,),
                  _accountsSectionWidget(),
                ],
              ),
            ))
    );
  }
  }


