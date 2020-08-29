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
}

class AccountTransferState {
  List<Account> accountsFrom;
  List<Account> accountsTo;
  bool isSubmitting = false;
  AccountTransferFormErrors errors;

  AccountTransferState(
      {this.accountsFrom, this.accountsTo, this.isSubmitting, this.errors});

  factory AccountTransferState.initial(List<Account> accounts) {
    return AccountTransferState(
        accountsFrom: accounts,
        accountsTo: null,
        isSubmitting: false,
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
    AccountTransferFormErrors errors
  }){
    return AccountTransferState(
      accountsTo: accountsTo ?? this.accountsTo,
      accountsFrom: accountsFrom ?? this.accountsFrom,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errors: errors ?? this.errors
    );
  }
}
