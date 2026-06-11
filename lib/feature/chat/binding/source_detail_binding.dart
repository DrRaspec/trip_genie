import 'package:ai_chat_bot/feature/chat/data/data_sources/trip_genie_api.dart';
import 'package:ai_chat_bot/feature/chat/data/repositories/resource_repository_impl.dart';
import 'package:ai_chat_bot/feature/chat/domain/repositories/resource_repository.dart';
import 'package:ai_chat_bot/feature/chat/presentation/view_model/source_detail_view_model.dart';
import 'package:get/get.dart';

class SourceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResourceRepository>(
      () => ResourceRepositoryImpl(api: Get.find<TripGenieApi>()),
    );

    Get.lazyPut<SourceDetailViewModel>(
      () => SourceDetailViewModel(repository: Get.find<ResourceRepository>()),
    );
  }
}
