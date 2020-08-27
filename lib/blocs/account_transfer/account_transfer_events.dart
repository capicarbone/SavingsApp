
// Events
// -- SubmitForm
// -- FromSelected
// -- ToSelected

class AccountTransferEvent {}

class AccountTransferSubmitFormEvent extends AccountTransferEvent {
  String amount;
  String accountFromId;
  String accountToId;
}

class AccountTransferFromSelectedEvent extends AccountTransferEvent{
  String accountFromId;

  AccountTransferFromSelectedEvent({this.accountFromId});
}

