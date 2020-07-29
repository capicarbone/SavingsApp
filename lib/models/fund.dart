
import 'package:savings_app/models/category.dart';

class Fund {

  String id;
  String name;
  String description;
  double minimumLimit;
  double maximumLimit;
  double percetageAssignment;
  double balance;
  List<Category> categories;

  Fund({this.id, this.name, this.description, this.maximumLimit, this.minimumLimit,
  this.percetageAssignment, this.balance, this.categories});

  factory Fund.fromMap(Map<String, dynamic> map) {
    //var l = ;
    return Fund(id: map['id'], name: map['name'], description: map['description'],
    maximumLimit: map['maximum_limit'], minimumLimit: map['minimum_limit'],
    percetageAssignment: map['percentage_assignment'], balance: map['balance'],
        categories: (map['categories'] as List<dynamic>).map((e) =>  Category.fromMap(e)
        ).toList());
  }
}