
import 'package:equatable/equatable.dart';
import 'package:savings_app/models/category.dart';

enum CategoryFormError {
  missingName,
  missingFund,
  serverError
}

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
  CategoryFormError error;
  SubmitFailedState({incomeMode, fundId, this.error}): super(incomeMode: incomeMode, fundId: fundId);

  List<Object> get props => [incomeMode, fundId, error];
}