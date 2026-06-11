import 'package:ai_chat_bot/app/routes/app_routes.dart';
import 'package:ai_chat_bot/feature/chat/binding/chat_binding.dart';
import 'package:ai_chat_bot/feature/chat/binding/source_detail_binding.dart';
import 'package:ai_chat_bot/feature/chat/presentation/view/chat_view.dart';
import 'package:ai_chat_bot/feature/chat/presentation/view/source_detail_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPage {
  static const String initial = AppRoutes.chat;

  static final routes = [
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),

    GetPage(
      name: AppRoutes.sourceDetail,
      page: () => const SourceDetailView(),
      binding: SourceDetailBinding(),
    ),
  ];
}
