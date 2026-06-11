import 'package:ai_chat_bot/app/app.dart';
import 'package:ai_chat_bot/app/config/env/env_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await EnvLoader.load();

  runApp(const App());
}
