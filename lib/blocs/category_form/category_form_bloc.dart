

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/category_form/category_form_events.dart';
import 'package:savings_app/blocs/category_form/category_form_states.dart';
import 'package:savings_app/repositories/categories_repository.dart';

class CategoryFormBloc extends Bloc<CategoryFormEvent, CategoryFormState> {

  String authToken;

  CategoryFormBloc({this.authToken}) : super(FormReadyState());

  @override
  Stream<CategoryFormState> mapEventToState(CategoryFormEvent event) async* {

    if (event is SubmitEvent) {

      yield SubmittingState();

      var repository = CategoriesRepository(authToken: authToken);
      CategoryPost data;

      if (event.isIncome) {
        data = CategoryPost.income(name: event.name);
      }else{
        data = CategoryPost.expense(name: event.name, fundId: event.fundId);
      }

      repository.post(data);


      yield SubmittedState();
    }

  }

}