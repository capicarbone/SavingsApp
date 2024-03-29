import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/category_form/category_form_events.dart';
import 'package:savings_app/blocs/category_form/category_form_states.dart';
import 'package:savings_app/repositories/categories_repository.dart';
import 'package:savings_app/repositories/user_repository.dart';

class CategoryFormBloc extends Bloc<CategoryFormEvent, CategoryFormState> {

  bool incomeMode = false;
  String fundId = null;

  CategoryFormBloc() : super(FormReadyState(incomeMode: false));

  @override
  Stream<CategoryFormState> mapEventToState(CategoryFormEvent event) async* {
    if (event is ChangeModeEvent) {
      incomeMode = event.incomeMode;

      yield FormReadyState(incomeMode: incomeMode, fundId: fundId);
    }

    if (event is ChangeFundEvent) {
      fundId = event.fundId;

      yield FormReadyState(incomeMode: incomeMode, fundId: fundId);
    }

    if (event is SubmitEvent) {
      yield SubmittingState(incomeMode: incomeMode, fundId: fundId);

      if (event.name.isEmpty) {
        yield SubmitFailedState(
            incomeMode: incomeMode,
            fundId: fundId,
            error: CategoryFormError.missingName);
      } else if (!incomeMode && fundId == null) {
        yield SubmitFailedState(
            incomeMode: incomeMode,
            fundId: fundId,
            error: CategoryFormError.missingFund);
      } else {
        yield SubmittingState(incomeMode: incomeMode, fundId: fundId);

        var repository = CategoriesRepository(authToken: UserRepository().restoreToken());
        CategoryPost data;

        if (incomeMode) {
          data = CategoryPost.income(name: event.name);
        } else {
          data = CategoryPost.expense(name: event.name, fundId: fundId);
        }

        try {
          await repository.save(data);

          incomeMode = false;
          fundId = null;
          yield SubmittedState(incomeMode: incomeMode, fundId: fundId);
        } catch (ex) {
          yield SubmitFailedState(
              incomeMode: incomeMode,
              fundId: fundId,
              error: CategoryFormError.serverError);
        }
      }
    }
  }
}
