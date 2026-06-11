import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'env_type.dart';

abstract final class EnvLoader {
  static Future<void> load() async {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');

    final envType = EnvType.fromString(env.trim().toLowerCase());

    switch (envType) {
      case EnvType.dev:
        await dotenv.load(fileName: 'env/.env.dev');
        break;

      case EnvType.staging:
        await dotenv.load(fileName: 'env/.env.staging');
        break;

      case EnvType.prod:
        await dotenv.load(fileName: 'env/.env.prod');
        break;
    }
  }
}
