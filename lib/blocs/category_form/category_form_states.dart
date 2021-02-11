
import 'package:equatable/equatable.dart';

class CategoryFormState extends Equatable {
  bool incomeMode = false;
  String fundId = null;

  List<Object> get props => [incomeMode, fundId];

  CategoryFormState({this.incomeMode, this.fundId});
}

class FormReadyState extends CategoryFormState {
  FormReadyState({incomeMode, fundId}): super(incomeMode: incomeMode, fundId: fundId);
}

class SubmittingState extends CategoryFormState {
  SubmittingState({incomeMode, fundId}): super(incomeMode: incomeMode, fundId: fundId);
}

class SubmittedState extends CategoryFormState {
  SubmittedState({incomeMode, fundId}): super(incomeMode: incomeMode, fundId: fundId);
}

class SubmitFailedState extends CategoryFormState {
  SubmitFailedState({incomeMode, fundId}): super(incomeMode: incomeMode, fundId: fundId);
}