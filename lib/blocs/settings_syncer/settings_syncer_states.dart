// State initital
// State syncing (is initial or not)
// settings updated
// settings syncFailed
import 'package:equatable/equatable.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';

abstract class SettingsSyncState extends Equatable {
  const SettingsSyncState();

  @override
  List<Object> get props => [];
}

class InitialSync extends SettingsSyncState {}

class SyncingSettings extends SettingsSyncState {
  bool initial = true;

  SyncingSettings({this.initial});

  @override
  List<Object> get props => [initial];
}

class DataContainerState extends SettingsSyncState {
  List<Category> categories;
  List<Account> accounts;
  List<Fund> funds;
  final double generalBalance;

  DataContainerState(
      {this.categories, this.accounts, this.funds, this.generalBalance});

  @override
  List<Object> get props => [categories, accounts, funds, generalBalance];
}

class SettingsLoaded extends DataContainerState {
  SettingsLoaded(
      {List<Category> categories,
      List<Account> accounts,
      List<Fund> funds,
      double generalBalance})
      : super(
            categories: categories,
            accounts: accounts,
            funds: funds,
            generalBalance: generalBalance);
}

class LocalDataUpdated extends DataContainerState {
  LocalDataUpdated(
      {List<Category> categories,
      List<Account> accounts,
      List<Fund> funds,
      double balance})
      : super(
            categories: categories,
            accounts: accounts,
            funds: funds,
            generalBalance: balance);
}

class SyncFailed extends SettingsSyncState {
  String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
