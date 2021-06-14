
class AccountFormEvent {}

class SubmitEvent extends AccountFormEvent {
  String name;
  String initialBalance;

  SubmitEvent({this.name, this.initialBalance});
}