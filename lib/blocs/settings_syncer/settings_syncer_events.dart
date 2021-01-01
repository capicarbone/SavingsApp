
import 'package:equatable/equatable.dart';

abstract class SettingsSyncerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsSyncerSyncRequested extends SettingsSyncerEvent {}

class SettingsSyncerDataUpdated extends SettingsSyncerEvent {}