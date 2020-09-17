import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_states.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/categories_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';
import 'package:meta/meta.dart';

class SettingsSyncerBloc extends Bloc<SettingsSyncerEvent, SettingsSyncState> {
  AccountsRepository accountsRepository;
  FundsRepository fundsRepository;
  CategoriesRepository categoriesRepository;

  SettingsSyncerBloc(
      {@required this.accountsRepository, @required this.fundsRepository,
      @required this.categoriesRepository})
      : super(SyncInitial());

  @override
  Stream<SettingsSyncState> mapEventToState(SettingsSyncerEvent event) async* {
    if (event is SettingsSyncerUpdateRequested) {
      yield SyncingSettings(initial: true);
      await categoriesRepository.fetchCategories();
      await accountsRepository.fetchUserAccounts();
      await fundsRepository.fetchUserFunds();
      yield SettingsUpdated();
    }
  }
}
