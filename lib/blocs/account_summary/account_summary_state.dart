
class AccountSummaryState {
  final double balance;

  AccountSummaryState(this.balance);
}

class AccountSummaryInitialState extends AccountSummaryState {

  AccountSummaryInitialState(double balance): super(balance);
}

class AccountSummaryBalanceUpdated extends AccountSummaryState {

  AccountSummaryBalanceUpdated(balance): super(balance);
}