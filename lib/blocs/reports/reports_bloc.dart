
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/reports/reports_events.dart';
import 'package:savings_app/blocs/reports/reports_states.dart';
import 'package:savings_app/models/period_statement.dart';
import 'package:savings_app/repositories/month_statements_repository.dart';
import 'package:savings_app/repositories/user_repository.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  int nextPage = 1;
  List<PeriodStatement> allStatements = [];

  ReportsBloc() : super(InitialState());

  @override
  Stream<ReportsState> mapEventToState(ReportsEvent event) async* {


    if (event is ReloadData){
      nextPage = 1;
      allStatements.clear();
    }

    if (event is LoadNextPage || event is ReloadData) {

      yield GettingPage();

      var authToken = UserRepository().restoreToken();

      var repository = MonthStatementsRepository(authToken: authToken);

      try{
        // TODO: Ask entire years, given that by just page could lead to incomplete years calculations
        var statements = await repository.fetch(nextPage);
        
        _prepareStatements(statements);

        allStatements.addAll(statements);
        yield PageLoaded(nextPage, allStatements);
        nextPage++;
      }catch (ex){
        yield PageLoadFailed(ex.toString());
      }

    }
  }

  /**
   * Orders statements according to levels and years groups.
   */
  void _prepareStatements(List<PeriodStatement> statements){

    statements.sort((a, b) => a.level.compareTo(b.level) );

    var yearStatementsIndexes = [];

    for (var i = 0; i < statements.length ; i++){
      if (statements[i].isYear) {
        yearStatementsIndexes.add(i);
      }
    }

    yearStatementsIndexes.forEach((yearIndex) {
      var year = statements[yearIndex].year;
      var monthStatementIndex = yearIndex;
      var nextInsertionIndex = yearIndex + 1;
      while (monthStatementIndex != -1){
        monthStatementIndex = statements.indexWhere((element) => element.year == year, monthStatementIndex + 1);
        if (monthStatementIndex != -1){
          final monthStatement = statements[monthStatementIndex];
          statements.removeAt(monthStatementIndex);
          statements.insert(nextInsertionIndex, monthStatement);
          nextInsertionIndex++;
        }
      }
    });

  }

}