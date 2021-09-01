import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_states.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/categories_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';
import 'package:savings_app/screens/reports_screen.dart';
import 'package:savings_app/widgets/balance.dart';
import 'package:savings_app/widgets/new_transaction.dart';
import 'package:savings_app/widgets/settings.dart';
import 'package:savings_app/widgets/user_settings.dart';

class HomeScreen extends StatefulWidget {
  String authToken;

  HomeScreen({@required this.authToken});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedPageIndex = 1;

  CategoriesRepository _categoriesRepository;
  FundsRepository _fundsRepository;
  AccountsRepository _accountsRepository;

  Widget _body() {
    return SafeArea(
      child: BlocProvider(
        create: (context) {
          return SettingsSyncerBloc();
        },
        child: BlocBuilder<SettingsSyncerBloc, SettingsSyncState>(
            //buildWhen: (context, state) =>
              //  state is SettingsLoaded || state is InitialSync,
            builder: (context, state) {
              if (state is InitialSync)
                BlocProvider.of<SettingsSyncerBloc>(context)
                    .add(SettingsSyncerSyncRequested());

              if (state is SettingsLoaded) {
                return UserSettings(
                  settings: state.settings,
                  child: IndexedStack(
                    index: _selectedPageIndex,
                    children: [
                      const BalanceScreen(),
                      //const NewTransactionScreen(),
                      const ReportsScreen(),
                      const SettingsScreen()
                    ],
                  ),
                );
              }

              return Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text("Syncing")
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  void _onTabSelected(int pageIndex) {
    setState(() {
      _selectedPageIndex = pageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _body(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, NewTransactionScreen.routeName);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          child: LayoutBuilder(builder: (context, constraints) {
            return Row(
              children: [
                SizedBox(
                  height: 60,
                  width: constraints.maxWidth - 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _NavigationItem(
                        index: 0,
                        label: "Balance",
                        icon: Icons.account_balance,
                        onPressed: _onTabSelected,
                        isSelected: _selectedPageIndex == 0,
                      ),
                      _NavigationItem(
                        index: 1,
                        label: "Reports",
                        icon: Icons.score,
                        onPressed: _onTabSelected,
                        isSelected: _selectedPageIndex == 1,
                      ),
                      _NavigationItem(
                          index: 2,
                          label: "Settings",
                          icon: Icons.settings,
                          onPressed: _onTabSelected,
                          isSelected: _selectedPageIndex == 2)
                    ],
                  ),
                ),
              ],
            );
          }),
        ));
  }
}

class _NavigationItem extends StatelessWidget {
  final int index;
  final String label;
  final IconData icon;
  final bool isSelected;
  final ValueChanged<int> onPressed;
  const _NavigationItem(
      {Key key,
      String this.label,
      IconData this.icon,
      this.index,
      this.onPressed,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => onPressed(index),
          child: Center(
            child: Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
