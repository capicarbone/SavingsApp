// States
// -- Initial
// -- Enalbled
// -- - Available Fields
// -- ReceiverEnabled
// -- SubmittingForm
// -- InvalidForm

// TODO: Create just one clase with several fields

import 'package:savings_app/models/account.dart';

class AccountTransferFormErrors {
  String amountErrorMessage;
  String accountFromMessage;
  String accountToMessage;
  String descriptionMessage;
  String submitError;

  AccountTransferFormErrors({this.amountErrorMessage, this.accountFromMessage,
  this.accountToMessage, this.descriptionMessage, this.submitError});
}

class AccountTransferState {
  List<Account> accountsFrom;
  List<Account> accountsTo;
  bool isSubmitting = false;
  bool successSubmit = false;
  AccountTransferFormErrors errors;

  AccountTransferState(
      {this.accountsFrom, this.accountsTo, this.isSubmitting, this.successSubmit, this.errors});

  factory AccountTransferState.initial() {
    return AccountTransferState(
        accountsFrom: null,
        accountsTo: null,
        isSubmitting: false,
        successSubmit: false,
        errors: null);
  }

  factory AccountTransferState.withAccountsTo(List<Account> accounts, List<Account> accountsTo) {
    return AccountTransferState(
      accountsFrom: accounts,
      accountsTo: accountsTo,
      isSubmitting: false,
      errors: null,
    );
  }

  AccountTransferState copyWith({
    List<Account> accountsFrom,
    List<Account> accountsTo,
    bool isSubmitting,
    bool successSubmit,
    AccountTransferFormErrors errors
  }){
    return AccountTransferState(
      accountsTo: accountsTo ?? this.accountsTo,
      successSubmit: successSubmit ?? this.successSubmit,
      accountsFrom: accountsFrom ?? this.accountsFrom,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errors: errors ?? this.errors
    );
  }
}
