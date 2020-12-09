import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/repositories/web_repository.dart';

import '../app_settings.dart';

class CategoriesRepository extends WebRepository{

  Box<Category> get box => Hive.box('categories');

  CategoriesRepository({String authToken}) : super(authToken: authToken);

  Future<List<Category>> sync() async {

    var url = "${AppSettings.getAPIHost()}transactions/categories";
    var headers = getAuthenticatedHeader();

    final response = await http.get(url, headers: headers);

    print(response.body);

    if (response.statusCode == 200) {
      List<dynamic> objects = json.decode(response.body);

      List<Category> categories = [];

      categories.addAll(objects.map((e) => Category.fromMap(e)));

      await box.clear();
      box.putAll( { for (var cat in categories) cat.id: cat} );

      return categories;
    }else {
      throw Exception(response.body);
    }

    return null;
  }

  List<Category> restore(){
    List<Category>  list = [];
    box.values.forEach((element) => list.add(element));
    return list;
  }


}