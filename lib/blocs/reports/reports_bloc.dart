
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/reports/reports_events.dart';
import 'package:savings_app/blocs/reports/reports_states.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  int nextPage = 0;

  ReportsBloc() : super(InitialState());

  @override
  Stream<ReportsState> mapEventToState(ReportsEvent event) async* {

    if (event is LoadNextPage) {

      yield PageLoaded(nextPage, []);
      nextPage++;
    }
  }

}