
import 'package:meta/meta.dart';

class AccountTransferPost {
  final double amount;
  final DateTime dateAccomplished;
  final String accountFromId;
  final String accountToId;
  final String description;

  const AccountTransferPost({@required this.amount, @required this.dateAccomplished,
  @required this.accountToId, @required this.accountFromId, this.description = ""});
}