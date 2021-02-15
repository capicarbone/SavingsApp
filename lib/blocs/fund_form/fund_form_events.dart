
import 'package:flutter/cupertino.dart';

class FundFormEvent {}

class SubmitEvent extends FundFormEvent {
  String name;
  String description;
  String assignment;
  String minimumLimit;
  String maximumLimit;

  SubmitEvent({@required this.name,
    @required this.description,
    @required this.assignment,
    @required this.maximumLimit,
    @required this.minimumLimit
  });
}