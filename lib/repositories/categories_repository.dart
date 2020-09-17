import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:savings_app/models/category.dart';
import 'package:savings_app/repositories/web_repository.dart';

import '../app_settings.dart';

class CategoriesRepository extends WebRepository{
  List<Category> _categories = [];

  get categories => _categories;

  CategoriesRepository({String authToken}) : super(authToken: authToken);

  Future<List<Category>> fetchCategories() async {

    var url = "${AppSettings.getAPIHost()}transactions/categories";
    var headers = getAuthenticatedHeader();

    final response = await http.get(url, headers: headers);

    print(response.body);

    if (response.statusCode == 200) {
      List<dynamic> objects = json.decode(response.body);

      _categories.clear();
      _categories.addAll(objects.map((e) => Category.fromMap(e)));

      return _categories;
    }else {
      throw Exception(response.body);
    }

    return null;
  }
}