
abstract class WebRepository {
  String authToken;

  WebRepository({this.authToken});

  Map<String, String> getAuthenticatedHeader() {
    return {"Authorization": "Bearer $authToken"};
  }
}