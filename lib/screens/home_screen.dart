import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_bloc.dart';
import 'package:savings_app/blocs/authentication/authentication_events.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_states.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';
import 'package:savings_app/widgets/my_summary.dart';

class HomeScreen extends StatelessWidget {
  String authToken;

  HomeScreen({@required this.authToken});

  @override
  Widget build(BuildContext context) {
    // TODO: Move to initialState
    var accountsRepository = AccountsRepository(authToken: authToken);
    var fundsRepository = FundsRepository(authToken: authToken);

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
      body: BlocProvider(
        create: (context) {
          return SettingsSyncerBloc(accountsRepository: accountsRepository, fundsRepository: fundsRepository);
        },
        child: BlocBuilder<SettingsSyncerBloc, SettingsSyncState>(
            builder: (context, state) {
          // TODO: Improvable
          if (state is SyncInitial)
            BlocProvider.of<SettingsSyncerBloc>(context)
                .add(SettingsSyncerUpdateRequested());


          if (state is SettingsUpdated || (state is SyncingSettings && !state.initial) ) {
            var bloc = BlocProvider.of<SettingsSyncerBloc>(context);
            return MySummary(
              token: authToken,
              fundsRepository: bloc.fundsRepository,
              accountsRepository: bloc.accountsRepository,
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
}
