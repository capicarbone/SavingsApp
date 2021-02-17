
class AccountFormEvent {}

class SubmitEvent extends AccountFormEvent {
  String name;

  SubmitEvent({this.name});
}