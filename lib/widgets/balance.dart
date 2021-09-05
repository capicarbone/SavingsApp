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
import 'package:savings_app/widgets/utils.dart';

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
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
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
      ),
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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Funds".toUpperCase(),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              decoration: cardDecoration,
              child: Column(
                children: funds.asMap().entries.map((entry) {
                  var e = entry.value;
                  var i = entry.key;
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(FundDetailsScreen.routeName,
                          arguments: {'fund': e});
                    },
                    child: Column(
                      children: [
                        ListTile(
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
                        if (i != funds.length - 1) const CardDivider()
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountsSectionWidget(List<Account> accounts) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Accounts".toUpperCase(),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: 12,),
            Container(
              decoration: cardDecoration,
              child: Column(
                children: accounts.asMap().entries
                    .map((entry) {
                      final e = entry.value;
                      final i = entry.key;
                      return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                AccountDetailsScreen.routeName,
                                arguments: {'account': e}).then((_) {
                              _refresh(context);
                            });
                          },
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  e.name,
                                ),
                                trailing: CurrencyValue(
                                  e.balance,
                                  style: TextStyle(
                                      color: e.balance < 0 ? Colors.red : Colors.black,
                                      fontSize: 16),
                                ),
                              ),
                              if (i != accounts.length - 1)
                              const CardDivider()
                            ],
                          ),
                        );})
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = UserSettings.of(context);
    return ContentSurface(
      child: Container(
        child: Column(
          children: <Widget>[
            _Balance(
              balance: settings.generalBalance,
            ),
            Flexible(
              child: LayoutBuilder(
                builder: (context, contraints) {
                  return Container(
                    height: contraints.maxHeight,
                    child: PageView(
                      children: [
                        _fundsSectionWidget(settings.funds),
                        _accountsSectionWidget(settings.accounts),
                      ],
                    ),
                  );
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}
