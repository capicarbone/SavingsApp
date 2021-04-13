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

      categories = (event.categories) ? categoriesRepository.restore() : categories;
      funds = (event.funds) ? fundsRepository.restore() : funds;
      accounts = (event.accounts) ? accountsRepository.restore() : accounts;

      yield LocalDataUpdated(
          categories: categories,
          accounts: accounts,
          funds: funds
      );
    }

    if (event is SettingsSyncerSyncRequested) {

      yield SyncingSettings(initial: true);

      // TODO: Validates if data exits. If not, keep loading/syncing state until
      // syncing has finished.


      // TODO: This should be smarter, like download every check each repository
      // and load according
      if (!categoriesRepository.isLocallyEmpty() &&
          !fundsRepository.isLocallyEmpty() &&
          !accountsRepository.isLocallyEmpty() ) {

        categories = categoriesRepository.restore();
        accounts = accountsRepository.restore();
        funds = fundsRepository.restore();

        yield SettingsLoaded( 
            categories: categories,
            accounts: accounts,
            funds: funds
        );
      }
      
      categories = await categoriesRepository.sync();
      accounts = await accountsRepository.sync();
      funds = await fundsRepository.sync();

      yield SettingsLoaded(
          categories: categories,
          accounts: accounts,
          funds: funds
      );
    }
  }
}
