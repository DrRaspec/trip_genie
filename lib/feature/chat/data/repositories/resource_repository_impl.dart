import 'package:ai_chat_bot/feature/chat/data/data_sources/trip_genie_api.dart';
import 'package:ai_chat_bot/feature/chat/data/models/resource_detail.dart';
import 'package:ai_chat_bot/feature/chat/domain/repositories/resource_repository.dart';
import 'package:dio/dio.dart';

class ResourceRepositoryImpl extends ResourceRepository {
  ResourceRepositoryImpl({required this._api});

  final TripGenieApi _api;

  @override
  Future<ResourceDetail> getResourceDetail(
    String slug, {
    CancelToken? cancelToken,
  }) async {
    final response = await _api.getResourceDetail(
      slug,
      cancelToken: cancelToken,
    );

    return response;
  }
}
