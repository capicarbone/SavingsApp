class InOutFormEvent {}

class InOutFormSubmitEvent extends InOutFormEvent {
  String amount;
  String accountId;
  String categoryId;
  String description;

  InOutFormSubmitEvent(
      {this.amount, this.accountId, this.categoryId, this.description});
}

//class InOutFormFieldsUpdatedEvent extends InOutFormEvent {}
