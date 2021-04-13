
import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 2)
class Account {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  double balance = 0;

  Account({this.id, this.name, this.balance = 0});

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(id: map['id'], name: map['name'],
    balance: map['balance']);
  }

  factory Account.copy(Account from) {
    return Account(id: from.id, name: from.name, balance: from.balance);
  }

}