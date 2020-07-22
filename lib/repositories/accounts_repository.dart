
import 'package:http/http.dart' as http;

class AccountsRepository {
  String authToken;

  AccountsRepository({this.authToken});

  Future<String> getUserAccounts() async {

    print("Bearer $authToken");

    final response = await http.get("https://flask-mymoney.herokuapp.com/api/accounts",
      headers: {"Authorization": "Bearer $authToken"});

    print (response.body);

    return response.body;

  }
}