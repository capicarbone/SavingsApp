
import 'package:meta/meta.dart';

class CategoryFormEvent {}

class SubmitEvent extends CategoryFormEvent {
  String name;

  SubmitEvent({@required this.name});

}

class ChangeModeEvent extends CategoryFormEvent {
  bool incomeMode;

  ChangeModeEvent({this.incomeMode});
}

class ChangeFundEvent extends CategoryFormEvent {
  String fundId;

  ChangeFundEvent({this.fundId});
}