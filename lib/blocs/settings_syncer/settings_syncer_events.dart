
import 'package:equatable/equatable.dart';

abstract class SettingsSyncerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsSyncerSyncRequested extends SettingsSyncerEvent {}

class ReloadLocalData extends SettingsSyncerEvent {
  var categories = false;
  var accounts = false;
  var funds = false;
  
  ReloadLocalData({this.categories = false, this.accounts = false, this.funds = false});
}