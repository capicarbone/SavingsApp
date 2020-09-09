
class AccountTransactionsEvent {}

class AccountTransactionsLoad extends AccountTransactionsEvent {}

class AccountTransactionsDeleteEvent extends AccountTransactionsEvent {
  String accountId;
  String transactionId;

  AccountTransactionsDeleteEvent(this.accountId, this.transactionId);
}