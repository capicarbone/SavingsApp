
// State initital
// State syncing (is initial or not)
// settings updated
// settings syncFailed

import 'package:equatable/equatable.dart';
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';

abstract class SettingsSyncState extends Equatable{
  const SettingsSyncState();

  @override
  List<Object> get props => [];

}

class SyncInitial extends SettingsSyncState {}

class SyncingSettings extends SettingsSyncState {
  bool initial = true;

  SyncingSettings({this.initial});

  @override
  List<Object> get props => [initial];
}

class SettingsLoaded extends  SettingsSyncState {
  List<Category> categories;
  List<Account> accounts;
  List<Fund> funds;

  SettingsLoaded({this.categories, this.accounts, this.funds});
}

class SyncFailed extends SettingsSyncState {
  String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}