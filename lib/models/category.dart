

import 'package:meta/meta.dart';
import 'package:hive/hive.dart';

// Categories for transactions

part 'category.g.dart';

@HiveType(typeId: 1)
class Category {

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String kind;

  Category({@required this.id, @required this.name,@required this.kind});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(name: map['name'], id: map['id'], kind: map['kind']);
  }

  get isIncome => kind == "income";

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) {
    var otherCat = other as Category;
    return id == otherCat.id;
  }
}