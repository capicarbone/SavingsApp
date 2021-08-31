
import 'package:savings_app/models/account.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';

class SettingsData {
  final List<Category> categories;
  final List<Account> accounts;
  final List<Fund> funds;

  SettingsData({this.categories, this.accounts, this.funds});

}