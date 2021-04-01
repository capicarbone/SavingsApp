
import 'package:savings_app/models/period_statement.dart';

class ReportsState {}

class InitialState extends ReportsState {}

class PageLoaded extends ReportsState {
  final int pageLoaded;
  final List<PeriodStatement> monthStatements;

  PageLoaded(this.pageLoaded, this.monthStatements);
}

class PageLoadFailed extends ReportsState {
  final String message;

  PageLoadFailed(this.message);
}