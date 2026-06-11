import 'package:ai_chat_bot/feature/chat/data/data_sources/trip_genie_api.dart';
import 'package:ai_chat_bot/feature/chat/data/repositories/chat_repository_impl.dart';
import 'package:ai_chat_bot/feature/chat/domain/repositories/chat_repository.dart';
import 'package:ai_chat_bot/feature/chat/presentation/view_model/chat_view_model.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatRepository>(
      () => ChatRepositoryImpl(Get.find<TripGenieApi>()),
    );
    Get.lazyPut(() => ChatViewModel());
  }
}
