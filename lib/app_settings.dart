
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppSettings {

  static String getAPIHost() => dotenv.env['API_HOST'];
}