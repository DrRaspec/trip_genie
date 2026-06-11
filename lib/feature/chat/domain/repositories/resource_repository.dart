import 'package:ai_chat_bot/feature/chat/data/models/resource_detail.dart';

abstract class ResourceRepository {
  Future<ResourceDetail> getResourceDetail(String slug);
}