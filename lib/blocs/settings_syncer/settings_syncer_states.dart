
// State initital
// State syncing (is initial or not)
// settings updated
// settings syncFailed

import 'package:equatable/equatable.dart';

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

class SettingsUpdated extends  SettingsSyncState {}

class SyncFailed extends SettingsSyncState {
  String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}