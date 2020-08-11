
import 'package:meta/meta.dart';

class InOutFormEvent {}

class InOutFormSubmitEvent extends InOutFormEvent {
  String amount;
  String accountId;
  String categoryId;
  String description;
  DateTime accomplishedAt;

  InOutFormSubmitEvent(
      {@required this.amount, @required this.accountId, @required this.accomplishedAt, this.categoryId, this.description});
}

//class InOutFormFieldsUpdatedEvent extends InOutFormEvent {}
