import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/settings_data.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/categories_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';
import 'package:meta/meta.dart';
import 'package:savings_app/repositories/user_repository.dart';

class SettingsSyncerBloc extends Bloc<SettingsSyncerEvent, SettingsSyncState> {
  List<Category> categories;
  List<Fund> funds;
  List<Account> accounts;

  AccountsRepository _accountsRepository;
  FundsRepository _fundsRepository;
  CategoriesRepository _categoriesRepository;

  SettingsSyncerBloc()
      : super(InitialSync());

  @override
  Stream<SettingsSyncState> mapEventToState(SettingsSyncerEvent event) async* {

    final userRepository = UserRepository();
    final authToken = userRepository.restoreToken();

    _categoriesRepository = CategoriesRepository(authToken: authToken);
    _fundsRepository = FundsRepository(authToken: authToken);
    _accountsRepository = AccountsRepository(authToken: authToken);

    if (event is ReloadLocalData) {
      _loadCache(event.accounts, event.funds, event.categories);

      yield LocalDataUpdated(
        settings: SettingsData(categories: categories,
          accounts: accounts,
          funds: funds,),);
    }

    if (event is SettingsSyncerSyncRequested) {
      yield SyncingSettings(initial: true);

      // TODO: Ask if db it's not initialized
      if (!_categoriesRepository.isLocallyEmpty() &&
          !_fundsRepository.isLocallyEmpty() &&
          !_accountsRepository.isLocallyEmpty()) {
        _loadAllCache();

        yield SettingsLoaded(
          settings: SettingsData(categories: categories,
            accounts: accounts,
            funds: funds,),);
      }

      await _syncAll();

      _loadAllCache();

      yield SettingsLoaded(
        settings: SettingsData(
          categories: categories,
          accounts: accounts,
          funds: funds,
        ),);
    }
  }



  void _loadCache(bool loadAccounts, bool loadFunds, bool loadCategories) {
    categories =
        loadCategories ? _categoriesRepository.restoreSorted() : categories;
    funds = loadFunds ? _fundsRepository.restoreSorted() : funds;
    accounts = loadAccounts ? _accountsRepository.restoreSorted() : accounts;
  }

  void _loadAllCache() {
    _loadCache(true, true, true);
  }

  Future<void> _syncAll() async {
    await _categoriesRepository.sync();
    await _accountsRepository.sync();
    await _fundsRepository.sync();
  }
}
