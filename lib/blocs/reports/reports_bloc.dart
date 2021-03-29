
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/reports/reports_events.dart';
import 'package:savings_app/blocs/reports/reports_states.dart';
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
        var statements = await repository.fetch(nextPage);

        statements.sort((a, b) => DateTime(b.year, b.month).compareTo(DateTime(a.year, a.month)) );

        yield PageLoaded(nextPage, statements);
        nextPage++;
      }catch (ex){
        yield PageLoadFailed(ex.toString());
      }

    }
  }

}