
// Events
// -- SubmitForm
// -- FromSelected
// -- ToSelected

class AccountTransferEvent {}

class AccountTransferSubmitFormEvent extends AccountTransferEvent {}

class AccountTransferFromSelectedEvent extends AccountTransferEvent{
  String accountFromId;

  AccountTransferFromSelectedEvent({this.accountFromId});
}

