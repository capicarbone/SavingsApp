
import 'package:meta/meta.dart';

// Categories for transactions

class Category {
  String id;
  String name;

  Category({@required this.id, @required this.name});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(name: map['name'], id: map['id']);
  }
}