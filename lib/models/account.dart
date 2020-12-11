
import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 2)
class Account {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  double balance;

  Account({this.id, this.name, this.balance});

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(id: map['id'], name: map['name'],
    balance: map['balance']);
  }

}