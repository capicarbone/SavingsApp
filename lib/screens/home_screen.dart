import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_events.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_states.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/categories_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';
import 'package:savings_app/repositories/transactions_repository.dart';
import 'package:savings_app/widgets/in_out_form.dart';
import 'package:savings_app/widgets/my_summary.dart';
import 'package:savings_app/widgets/new_transaction.dart';

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
  TransactionsRepository _transactionsRepository;
  SettingsSyncerBloc _syncerBloc;

  initState(){
    super.initState();

    _categoriesRepository = CategoriesRepository(authToken: widget.authToken);
    _fundsRepository = FundsRepository(authToken: widget.authToken);
    _accountsRepository = AccountsRepository(authToken: widget.authToken);

    _transactionsRepository = TransactionsRepository(
        authToken: widget.authToken
    );

    _syncerBloc = SettingsSyncerBloc(
      categoriesRepository: _categoriesRepository,
        accountsRepository: _accountsRepository,
        fundsRepository: _fundsRepository);
  }

  Widget _body() {

    return BlocProvider(
      create: (context) {
        return _syncerBloc;
      },
      child: BlocBuilder<SettingsSyncerBloc, SettingsSyncState>(
          builder: (context, state) {
        // TODO: Improvable
        if (state is SyncInitial)
          BlocProvider.of<SettingsSyncerBloc>(context)
              .add(SettingsSyncerUpdateRequested());

        if (state is SettingsLoaded ) {
          var bloc = BlocProvider.of<SettingsSyncerBloc>(context);
          return IndexedStack(
            index: _selectedPageIndex,
            children: [
              MySummary(
                  token: widget.authToken,
                  fundsRepository: _fundsRepository,
                  accountsRepository: _accountsRepository,
                  transactionsRepository: _transactionsRepository),
              NewTransaction(
                categories: state.categories,
                funds: state.funds,
                accounts: state.accounts,
                authToken: widget.authToken,
              ),
              Container(
                child: Center(
                  child: Text("Settings"),
                ),
              )
            ],
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
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLoggedOut());
            },
          )
        ],
      ),
      body: _body(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _onTabSelected,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), title: Text("Dashboard")),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), title: Text("New Transaction")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Settings"))
        ],
      ),
    );
  }
}
