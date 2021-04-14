// Events
// -- SubmitForm
// -- FromSelected
// -- ToSelected

import 'package:savings_app/models/account.dart';

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

class AccountFromSelectedEvent extends AccountTransferEvent {
  String accountFromId;
  List<Account> accounts;

  AccountFromSelectedEvent({this.accounts, this.accountFromId});
}
