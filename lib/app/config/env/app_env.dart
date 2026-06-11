import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppEnv {
  static String get baseUrl => dotenv.get('BASE_URL');
}
