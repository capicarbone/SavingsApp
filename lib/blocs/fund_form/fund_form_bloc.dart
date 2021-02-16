
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

      var dataChecks = _validateFormData(event, _getAvailableAssignment());

      if (dataChecks != null){
        yield dataChecks;
        return;
      }

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
        yield SubmitFailedState(error: FundFormError.serverError);
      }

    }

  }

  SubmitFailedState _validateFormData(SubmitEvent data, double availableAssignment){
    if (data.name.isEmpty){
      return SubmitFailedState(error: FundFormError.missingName);
    }

    if (data.assignment.isEmpty){
      return SubmitFailedState(error: FundFormError.missingAssignment);
    }

    double assignment;
    try{
      assignment = double.parse(data.assignment);
    }catch (ex){
      return SubmitFailedState(error: FundFormError.invalidAssignment);
    }

    if (assignment < 0 || assignment > 100) {
      return SubmitFailedState(error: FundFormError.invalidAssignment);
    }

    if (availableAssignment < assignment/100 ){
      return SubmitFailedState(error: FundFormError.overassignment);
    }

    if (data.maximumLimit.isNotEmpty){
      double maximum;
      try{
        maximum = double.parse(data.maximumLimit);
      }catch (ex){
        return SubmitFailedState(error: FundFormError.invalidLimit);
      }
    }

    if (data.minimumLimit.isNotEmpty) {
      double minimum;
      try{
        minimum = double.parse(data.minimumLimit);
      }catch (ex){
        return SubmitFailedState(error: FundFormError.invalidMinimum);
      }
    }
  }

  double _getAvailableAssignment(){
    var repository = FundsRepository(authToken: authToken);
    var funds = repository.restore();

    var totalAssigned = funds.fold(0, (previousValue, element) => previousValue + element.percetageAssignment);
    return 1 - totalAssigned;
  }



}