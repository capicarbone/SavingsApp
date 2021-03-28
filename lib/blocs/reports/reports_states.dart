
import 'package:savings_app/models/month_statement.dart';

class ReportsState {}

class InitialState extends ReportsState {}

class PageLoaded extends ReportsState {
  final int pageLoaded;
  final List<MonthStatement> monthStatements;

  PageLoaded(this.pageLoaded, this.monthStatements);
}

class PageLoadFailed extends ReportsState {
  final String message;

  PageLoadFailed(this.message);
}