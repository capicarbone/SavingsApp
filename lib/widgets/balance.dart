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
import 'package:savings_app/widgets/content_surface.dart';
import 'package:savings_app/widgets/currency_value.dart';
import 'package:savings_app/widgets/fund_status_bar.dart';
import 'package:savings_app/widgets/section_title.dart';
import 'package:savings_app/widgets/user_settings.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen();

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _Balance extends StatelessWidget {
  final double balance;
  const _Balance({Key key, this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(title: "Balance"),
        CurrencyValue(
          balance,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}

class _BalanceScreenState extends State<BalanceScreen> {
  void _refresh(BuildContext ctx) {
    //TODO: I should update from the database and not from the server
    // so, calling the SummaryBloc it should be the right choice.
    BlocProvider.of<SettingsSyncerBloc>(ctx).add(SettingsSyncerSyncRequested());
  }

  Widget _fundsSectionWidget(List<Fund> funds) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Funds".toUpperCase(),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Column(
            children: funds
                .map((e) => InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                    FundDetailsScreen.routeName,
                    arguments: {'fund': e});
              },
              child: ListTile(
                title: Text(
                  e.name,
                ),
                subtitle: Text(
                  "Receiving ${(e.percetageAssignment * 100).toStringAsFixed(0)}% of your income.",
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Column(
                  children: [
                    CurrencyValue(
                      e.balance,
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 6),
                        width: 100,
                        child: FundStatusBar(
                          fund: e,
                          balance: e.balance,
                        ))
                  ],
                ),
              ),
            ))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _accountsSectionWidget(List<Account> accounts) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Accounts".toUpperCase(),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          Column(
            children: accounts
                .map((e) => InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                    AccountDetailsScreen.routeName,
                    arguments: {'account': e}).then((_) {
                  _refresh(context);
                });
              },
              child: ListTile(
                title: Text(
                  e.name,
                ),
                trailing: CurrencyValue(
                  e.balance,
                  style: TextStyle(
                      color: e.balance < 0
                          ? Colors.red
                          : Colors.black,
                      fontSize: 16),
                ),
              ),
            ))
                .toList(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = UserSettings.of(context);
    return ContentSurface(
      child: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            _Balance(balance: settings.generalBalance,),
            SizedBox(
              height: 18,
            ),
            _fundsSectionWidget(settings.funds),
            SizedBox(
              height: 18,
            ),
            _accountsSectionWidget(settings.accounts),
          ],
        ),
      )),
    );
  }
}


