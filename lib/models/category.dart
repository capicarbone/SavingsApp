
import 'package:meta/meta.dart';

// Categories for transactions

class Category {
  String id;
  String name;
  String kind;

  Category({@required this.id, @required this.name,@required this.kind});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(name: map['name'], id: map['id'], kind: map['kind']);
  }

  get isIncome => kind == "income";
}