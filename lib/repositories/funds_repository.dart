
import 'package:http/http.dart' as http;

class FundsRepository {
  String authToken;

  FundsRepository({this.authToken});

  Future<String> getUserFunds() async {

    print("Bearer $authToken");

    final response = await http.get("https://flask-mymoney.herokuapp.com/api/funds",
        headers: {"Authorization": "Bearer $authToken"});

    print (response.body);

    return response.body;

  }
}