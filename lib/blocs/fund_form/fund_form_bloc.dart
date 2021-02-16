
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/fund_form/fund_form_events.dart';
import 'package:savings_app/blocs/fund_form/fund_form_states.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/funds_repository.dart';

class FundFormBloc extends Bloc<FundFormEvent, FundFormState> {

  FundsRepository repository;

  FundFormBloc({this.repository}) : 
        super(FormReadyState( availableForAssignment: repository.availableAssignment));

  


  @override
  Stream<FundFormState> mapEventToState(FundFormEvent event) async* {

    var availableAssignment = repository.availableAssignment;

    if (event is SubmitEvent) {

      yield SubmittingState(availableAssignment: availableAssignment);

      SubmitFailedState dataChecks;
      try {
         dataChecks = _validateFormData(event, availableAssignment);
      }catch (ex){
        yield SubmitFailedState(
            availableAssignment: availableAssignment,
            error: FundFormError.serverError
        );
        return;
      }


      if (dataChecks != null){
        yield dataChecks;
        return;
      }

      var fund = Fund(id: null, name: event.name,
      description: (event.description.isNotEmpty) ? event.description : null,
        maximumLimit: (event.maximumLimit.isNotEmpty)  ? double.parse(event.maximumLimit) : null,
        minimumLimit: (event.minimumLimit.isNotEmpty) ? double.parse(event.minimumLimit) : null,
        percetageAssignment: double.parse(event.assignment) / 100
      );

      try {
        await repository.save(fund);

        yield SubmittedState(availableAssignment: repository.availableAssignment);
      }catch (ex) {
        yield SubmitFailedState(
          availableAssignment: availableAssignment,
            error: FundFormError.serverError
        );
      }

    }

  }

  SubmitFailedState _validateFormData(SubmitEvent data, double availableAssignment){
    if (data.name.isEmpty){
      return SubmitFailedState(error: FundFormError.missingName,
          availableAssignment: availableAssignment);
    }

    if (data.assignment.isEmpty){
      return SubmitFailedState(error: FundFormError.missingAssignment,
      availableAssignment: availableAssignment);
    }

    double assignment;
    try{
      assignment = double.parse(data.assignment);
    }catch (ex){
      return SubmitFailedState(error: FundFormError.invalidAssignment,
      availableAssignment: availableAssignment);
    }

    if (assignment < 0 || assignment > 100) {
      return SubmitFailedState(error: FundFormError.invalidAssignment,
      availableAssignment: availableAssignment);
    }

    if (availableAssignment < assignment/100 ){
      return SubmitFailedState(error: FundFormError.overassignment,
      availableAssignment: availableAssignment);
    }

    double maximum;

    if (data.maximumLimit.isNotEmpty){

      try{
        maximum = double.parse(data.maximumLimit);
      }catch (ex){
        return SubmitFailedState(error: FundFormError.invalidLimit,
        availableAssignment: availableAssignment);
      }
    }

    double minimum;
    if (data.minimumLimit.isNotEmpty) {

      try{
        minimum = double.parse(data.minimumLimit);
      }catch (ex){
        return SubmitFailedState(error: FundFormError.invalidMinimum,
        availableAssignment: availableAssignment);
      }

    }

    if (data.minimumLimit.isNotEmpty && data.maximumLimit.isNotEmpty){
      if (minimum >= maximum){
        return SubmitFailedState(error: FundFormError.invalidMinimum,
            availableAssignment: availableAssignment);
      }
    }


  }





}