
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_states.dart';
import 'package:savings_app/repositories/accounts_repository.dart';

class SettingsSyncerBloc extends Bloc<SettingsSyncerEvent, SettingsSyncState> {

  AccountsRepository accountsRepository;

  SettingsSyncerBloc({this.accountsRepository}) : super(SyncInitial());

  @override
  Stream<SettingsSyncState> mapEventToState(SettingsSyncerEvent event) async* {

    if (event is SettingsSyncerUpdateRequested) {
      yield SyncingSettings(initial: false);
      await accountsRepository.getUserAccounts();
      yield SettingsUpdated();
    }
  }

}