
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/reports/reports_events.dart';
import 'package:savings_app/blocs/reports/reports_states.dart';
import 'package:savings_app/models/month_statement.dart';
import 'package:savings_app/repositories/month_statements_repository.dart';
import 'package:savings_app/repositories/user_repository.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  int nextPage = 0;

  ReportsBloc() : super(InitialState());

  @override
  Stream<ReportsState> mapEventToState(ReportsEvent event) async* {

    if (event is LoadNextPage) {

      var authToken = UserRepository().restoreToken();

      var repository = MonthStatementsRepository(authToken: authToken);

      try{
        // TODO: Ask entire years, given that by just page could lead to incomplete years calculations
        var statements = await repository.fetch(nextPage);
        
        _prepareStatements(statements);

        yield PageLoaded(nextPage, statements);
        nextPage++;
      }catch (ex){
        yield PageLoadFailed(ex.toString());
      }

    }
  }

  /**
   * Orders statements and adds years total.
   */
  void _prepareStatements(List<PeriodStatement> statements){

    statements.sort((a, b) => DateTime(b.year, b.month).compareTo(DateTime(a.year, a.month)) );

    var years = Set.from(statements.map((e) => e.year));
    var yearsStatements = <PeriodStatement>[];

    years.forEach((year) {
      var yearStatements = statements.where((statement) => statement.year == year).toList();
      yearsStatements.add(PeriodStatement.computeYear(yearStatements[0].year, yearStatements));
    });

    yearsStatements.forEach((yearStatement) {
      var insertionIndex = statements.indexWhere((element) {
        return element.year == yearStatement.year;
      } );
      statements.insert(insertionIndex, yearStatement);
    });

  }

}