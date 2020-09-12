
class AccountSummaryEvent {}

class AccountSummaryBalanceUpdateEvent extends AccountSummaryEvent{
  final double change;

  AccountSummaryBalanceUpdateEvent(this.change);
}