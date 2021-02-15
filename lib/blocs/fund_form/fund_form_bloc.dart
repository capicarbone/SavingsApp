
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/fund_form/fund_form_events.dart';
import 'package:savings_app/blocs/fund_form/fund_form_states.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/funds_repository.dart';

class FundFormBloc extends Bloc<FundFormEvent, FundFormState> {

  String authToken;

  FundFormBloc({this.authToken}) : super(FormReadyState());

  @override
  Stream<FundFormState> mapEventToState(FundFormEvent event) async* {

    if (event is SubmitEvent) {

      yield SubmittingState();

      var repository = FundsRepository(authToken: authToken);

      var fund = Fund(id: null, name: event.name,
      description: (event.description.isNotEmpty) ? event.description : null,
        maximumLimit: (event.maximumLimit.isNotEmpty)  ? double.parse(event.maximumLimit) : null,
        minimumLimit: (event.minimumLimit.isNotEmpty) ? double.parse(event.minimumLimit) : null,
        percetageAssignment: double.parse(event.assignment) / 100
      );

      try {
        await repository.save(fund);

        yield SubmittedState();
      }catch (ex) {
        yield SubmitFailedState();
      }




    }

  }



}