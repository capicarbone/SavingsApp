
abstract class SummaryState {}

class SummaryLoadingData extends SummaryState {}

class SummaryDataLoaded extends SummaryState {
  String funds;
  String accounts;

  SummaryDataLoaded({this.funds, this.accounts});
}
