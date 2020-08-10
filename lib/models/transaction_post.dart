
import 'package:meta/meta.dart';

class TransactionPost {
  final double amount;
  final String categoryId;
  final String accountId;
  final String description;
  final DateTime accomplishedAt;

  const TransactionPost({@required this.amount, @required this.accountId,
    @required this.accomplishedAt, this.categoryId, this.description });
}