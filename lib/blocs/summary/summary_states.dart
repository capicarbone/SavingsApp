
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/fund.dart';

abstract class SummaryState {}

class SummaryLoadingData extends SummaryState {}

class SummaryDataLoaded extends SummaryState {
  List<Fund> funds;
  List<Account> accounts;

  SummaryDataLoaded({this.funds, this.accounts});
}
