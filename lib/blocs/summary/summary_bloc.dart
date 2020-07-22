
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/summary/summary_events.dart';
import 'package:savings_app/blocs/summary/summary_states.dart';
import 'package:savings_app/repositories/accounts_repository.dart';
import 'package:savings_app/repositories/funds_repository.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  FundsRepository fundsRepository;
  AccountsRepository accountsRepository;

  SummaryBloc({this.accountsRepository, this.fundsRepository}) : super(SummaryLoadingData());

  @override
  Stream<SummaryState> mapEventToState(SummaryEvent event) async* {

    if (event is LoadDataEvent) {
      yield SummaryLoadingData();

      String funds = await fundsRepository.getUserFunds();
      Future.delayed(Duration(seconds: 5));

      yield SummaryDataLoaded(funds: funds, accounts: null);

      String accounts = await accountsRepository.getUserAccounts();

      yield SummaryDataLoaded(funds: funds, accounts: accounts);
    }
  }

}