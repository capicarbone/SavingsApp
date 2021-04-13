import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:savings_app/models/category.dart';
import 'package:savings_app/models/fund.dart';
import 'package:savings_app/repositories/web_repository.dart';

import '../app_settings.dart';

class CategoryPost{

  final String name;
  final String fundId;
  final String kind;

  const CategoryPost({this.name, this.fundId, this.kind});

  factory CategoryPost.income({String name}) {
    return CategoryPost(name: name, fundId: null, kind: 'income');
  }

  factory CategoryPost.expense({String name, String fundId}) {
    return CategoryPost(name: name, fundId: fundId, kind: 'expense');
  }
}

class CategoriesRepository extends WebRepository{

  Box<Category> get _box => Hive.box<Category>('categories');
  Box<Fund> get _fundsBox => Hive.box<Fund>('funds');

  CategoriesRepository({String authToken}) : super(authToken: authToken);

  Future<Category> post(CategoryPost data) async {
    var url = "${getHost()}transactions/categories";
    var headers = getAuthenticatedHeader();

    var body = {
      "name": data.name,
      "kind": data.kind
    };

    if (data.fundId != null){
      body["fund"] = data.fundId;
    }

    var response = await http.post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      var responseMap = json.decode(response.body);
      var category = Category(id: responseMap["id"], name: data.name , kind: data.kind);
      return category;
    } else {
      throw Exception(response.body);
    }
  }

  Future<Category> save(CategoryPost data) async {

    var newCategory = await post(data);

    await _box.put(newCategory.id, newCategory);

    // TODO: Change to add id
    if (!newCategory.isIncome) {
      var fund = _fundsBox.get(data.fundId);
      fund.categories.add(newCategory);
      _fundsBox.put(fund.id, fund);
    }

    return newCategory;

  }

  Future<List<Category>> sync() async {

    var url = "${getHost()}transactions/categories";
    var headers = getAuthenticatedHeader();

    final response = await http.get(url, headers: headers);

    print(response.body);

    if (response.statusCode == 200) {
      List<dynamic> objects = json.decode(response.body);

      List<Category> categories = [];

      categories.addAll(objects.map((e) => Category.fromMap(e)));
      categories.sort((a,b) => a.name.compareTo(b.name));

      await _box.clear();
      await _box.putAll( { for (var cat in categories) cat.id: cat} );

      return categories;
    }else {
      throw Exception(response.body);
    }

    return null;
  }

  List<Category> restore(){
    return [ for (var element in _box.values ) Category.copy(element) ];
  }

  List<Category> restoreIncomes(){
    return restore().where((element) => element.isIncome).toList();
  }

  List<Category> restoreExpenses(){
    return restore().where((element) => !element.isIncome).toList();
  }

  Category restoreById(String id){
    return restore().firstWhere((element) => element.id == id, orElse: () => null);
  }

  bool isLocallyEmpty() {
    return _box.isEmpty;
  }


}