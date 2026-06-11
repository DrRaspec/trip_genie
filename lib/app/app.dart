import 'package:ai_chat_bot/app/routes/app_page.dart';
import 'package:ai_chat_bot/app/routes/app_routes.dart';
import 'package:ai_chat_bot/app/theme/app_theme.dart';
import 'package:ai_chat_bot/core/di/app_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.chat,
      getPages: AppPage.routes,
    );
  }
}
