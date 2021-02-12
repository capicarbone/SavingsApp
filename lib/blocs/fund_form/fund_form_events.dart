
import 'package:flutter/cupertino.dart';

class FundFormEvent {}

class SubmitEvent extends FundFormEvent {
  String name;
  String description;
  String minimum_limit;
  String maximum_limit;

  SubmitEvent({@required this.name,
    @required this.description,
    @required this.maximum_limit,
    @required this.minimum_limit
  });
}