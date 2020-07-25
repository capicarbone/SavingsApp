
class Fund {

  String id;
  String name;
  String description;
  double minimumLimit;
  double maximumLimit;
  double percetageAssignment;
  double balance;

  Fund({this.id, this.name, this.description, this.maximumLimit, this.minimumLimit,
  this.percetageAssignment, this.balance});

  factory Fund.fromMap(Map<String, dynamic> map) {
    return Fund(id: map['id'], name: map['name'], description: map['description'],
    maximumLimit: map['maximum_limit'], minimumLimit: map['minimum_limit'],
    percetageAssignment: map['percentage_assignment'], balance: map['balance']);
  }
}