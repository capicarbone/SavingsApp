
import 'package:meta/meta.dart';

class CategoryFormEvent {}

class SubmitEvent extends CategoryFormEvent {
  String name;
  String fundId;
  bool isIncome;

  SubmitEvent({@required this.name, @required this.fundId, @required this.isIncome : true });

}