import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_events.dart';
import 'package:savings_app/blocs/settings_syncer/settings_syncer_states.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/categories_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';
import 'package:meta/meta.dart';

class SettingsSyncerBloc extends Bloc<SettingsSyncerEvent, SettingsSyncState> {

  List<Category> categories;
  List<Fund> funds;
  List<Account> accounts;

  AccountsRepository accountsRepository;
  FundsRepository fundsRepository;
  CategoriesRepository categoriesRepository;

  SettingsSyncerBloc(
      {@required this.accountsRepository, @required this.fundsRepository,
      @required this.categoriesRepository})
      : super(InitialSync());

  @override
  Stream<SettingsSyncState> mapEventToState(SettingsSyncerEvent event) async* {

    if (event is ReloadLocalData) {

      _loadCache(event.accounts, event.funds, event.categories);

      yield LocalDataUpdated(
          categories: categories,
          accounts: accounts,
          funds: funds,
          balance: _getBalance(accounts)
      );
    }

    if (event is SettingsSyncerSyncRequested) {

      yield SyncingSettings(initial: true);

      // TODO: Ask if db it's not initialized
      if (!categoriesRepository.isLocallyEmpty() &&
          !fundsRepository.isLocallyEmpty() &&
          !accountsRepository.isLocallyEmpty() ) {

        _loadAllCache();

        yield SettingsLoaded( 
            categories: categories,
            accounts: accounts,
            funds: funds,
            generalBalance: _getBalance(accounts)
        );
      }

      await _syncAll();
      
      _loadAllCache();

      yield SettingsLoaded(
          categories: categories,
          accounts: accounts,
          funds: funds,
          generalBalance: _getBalance(accounts)
      );
    }
  }

  double _getBalance(List<Account> acounts) {
    return accounts.fold(0.0, (previousValue, element) => previousValue + element.balance);
  }

  void _loadCache(bool loadAccounts, bool loadFunds, bool loadCategories){
    categories = loadCategories ? categoriesRepository.restoreSorted() : categories;
    funds = loadFunds ? fundsRepository.restoreSorted() : funds;
    accounts = loadAccounts ? accountsRepository.restoreSorted() : accounts;
  }

  void _loadAllCache(){
    _loadCache(true, true, true);
  }

  Future<void> _syncAll() async{
    await categoriesRepository.sync();
    await accountsRepository.sync();
    await fundsRepository.sync();
  }
}
