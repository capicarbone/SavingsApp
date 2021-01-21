
import 'package:savings_app/app_settings.dart';

abstract class WebRepository {
  String authToken;

  WebRepository({this.authToken});

  Map<String, String> getAuthenticatedHeader() {
    return {"Authorization": "Bearer $authToken"};
  }

  String getHost(){
    return AppSettings.getAPIHost();
  }
}