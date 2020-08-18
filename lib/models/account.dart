

class Account {

  final String id;
  final String name;
  double balance;

  Account({this.id, this.name, this.balance});

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(id: map['id'], name: map['name'],
    balance: map['balance']);
  }

}