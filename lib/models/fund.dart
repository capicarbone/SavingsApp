
import 'package:savings_app/models/category.dart';
import 'package:hive/hive.dart';

part 'fund.g.dart';

@HiveType(typeId: 3)
class Fund {

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  double minimumLimit;

  @HiveField(4)
  double maximumLimit;

  @HiveField(5)
  double percetageAssignment;

  @HiveField(6)
  double balance = 0;

  @HiveField(7)
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

  factory Fund.copy(Fund from){
    return Fund(id: from.id, name: from.name, description: from.description,
    minimumLimit: from.minimumLimit, maximumLimit: from.maximumLimit,
    percetageAssignment: from.percetageAssignment, balance: from.balance,
    categories: [ for (var cat in from.categories) Category.copy(cat) ]);
  }
}