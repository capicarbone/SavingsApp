
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/fund_form/fund_form_events.dart';
import 'package:savings_app/blocs/fund_form/fund_form_states.dart';

class FundFormBloc extends Bloc<FundFormEvent, FundFormState> {

  String authToken;

  FundFormBloc({this.authToken}) : super(FormReadyState());

  @override
  Stream<FundFormState> mapEventToState(FundFormEvent event) async* {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }



}