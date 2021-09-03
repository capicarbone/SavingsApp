// State initital
// State syncing (is initial or not)
// settings updated
// settings syncFailed
import 'package:equatable/equatable.dart';
import 'package:savings_app/models/settings_data.dart';
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

class SettingsLoaded extends SettingsSyncState{
  final SettingsData settings;

  SettingsLoaded(
      {this.settings});

  @override
  List<Object> get props => [settings];
}

class SyncFailed extends SettingsSyncState {
  String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
