// Events
// -- SubmitForm
// -- FromSelected
// -- ToSelected

class AccountTransferEvent {}

class AccountTransferSubmitFormEvent extends AccountTransferEvent {
  String amount;
  String accountFromId;
  String accountToId;
  String description;
  DateTime accomplishedAt;

  AccountTransferSubmitFormEvent(
      {this.amount,
      this.accountFromId,
      this.accountToId,
      this.description,
      this.accomplishedAt});
}

class AccountTransferFromSelectedEvent extends AccountTransferEvent {
  String accountFromId;

  AccountTransferFromSelectedEvent({this.accountFromId});
}
