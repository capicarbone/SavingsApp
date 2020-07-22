
import 'package:equatable/equatable.dart';

abstract class SettingsSyncerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SettingsSyncerUpdateRequested extends SettingsSyncerEvent {}