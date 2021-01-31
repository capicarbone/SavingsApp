

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:savings_app/blocs/category_form/category_form_events.dart';
import 'package:savings_app/blocs/category_form/category_form_states.dart';

class CategoryFormBloc extends Bloc<CategoryFormEvent, CategoryFormState> {

  String authToken;

  CategoryFormBloc({this.authToken}) : super(FormReadyState());

  @override
  Stream<CategoryFormState> mapEventToState(CategoryFormEvent event) async* {

    if (event is SubmitEvent) {

      yield SubmittingState();

      yield SubmittedState();
    }

  }

}