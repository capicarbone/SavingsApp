
class AccountTransactionsEvent {}

class LoadNextPageEvent extends AccountTransactionsEvent {
}

class DeleteTransactionEvent extends AccountTransactionsEvent {
  String accountId;
  String transactionId;

  DeleteTransactionEvent(this.accountId, this.transactionId);
}