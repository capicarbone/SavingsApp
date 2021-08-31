// State initital
// State syncing (is initial or not)
// settings updated
// settings syncFailed
import 'package:equatable/equatable.dart';
import 'package:savings_app/blocs/settings_data.dart';
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
  final SettingsData settings;
  final double generalBalance;

  DataContainerState(
      {this.settings, this.generalBalance});

  @override
  List<Object> get props => [settings, generalBalance];
}

class SettingsLoaded extends DataContainerState {
  SettingsLoaded(
      {SettingsData settings,
      double generalBalance})
      : super(
            settings: settings,
            generalBalance: generalBalance);
}

class LocalDataUpdated extends DataContainerState {
  LocalDataUpdated(
      {SettingsData settings,
      double balance})
      : super(
            settings: settings,
            generalBalance: balance);
}

class SyncFailed extends SettingsSyncState {
  String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
