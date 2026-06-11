import 'package:ai_chat_bot/core/network/api_client.dart';
import 'package:ai_chat_bot/core/network/dio_client.dart';
import 'package:ai_chat_bot/core/network/network_controller.dart';
import 'package:ai_chat_bot/core/network/network_info.dart';
import 'package:ai_chat_bot/core/services/deep_link_service.dart';
import 'package:ai_chat_bot/feature/chat/data/data_sources/trip_genie_api.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    final networkInfo = NetworkInfoImpl();

    Get.put<NetworkInfo>(networkInfo, permanent: true);

    Get.put<NetworkController>(NetworkController(networkInfo), permanent: true);

    final dio = DioClient.create();

    Get.put<Dio>(dio, permanent: true);

    Get.put<ApiClient>(ApiClient(dio), permanent: true);

    Get.lazyPut<TripGenieApi>(() => TripGenieApi(Get.find<ApiClient>()));

    Get.putAsync(() => DeepLinkService().init());
  }
}
