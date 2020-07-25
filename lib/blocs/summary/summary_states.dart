
import 'package:savings_app/models/account.dart';

abstract class SummaryState {}

class SummaryLoadingData extends SummaryState {}

class SummaryDataLoaded extends SummaryState {
  String funds;
  List<Account> accounts;

  SummaryDataLoaded({this.funds, this.accounts});
}
