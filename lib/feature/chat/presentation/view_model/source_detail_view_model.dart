import 'package:ai_chat_bot/core/utils/app_logger.dart';
import 'package:ai_chat_bot/feature/chat/data/models/resource_detail.dart';
import 'package:ai_chat_bot/feature/chat/domain/repositories/resource_repository.dart';
import 'package:get/get.dart';

class SourceDetailViewModel extends GetxController {
  SourceDetailViewModel({ResourceRepository? repository})
    : _repository = repository ?? Get.find<ResourceRepository>();

  final ResourceRepository _repository;

  String slug = '';

  final item = Rxn<ResourceDetail>();
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    AppLogger.info('SourceDetailViewModel initialized with args: $args');

    if (args is! Map<String, dynamic> ||
        args['slug'] == null ||
        args['slug'].toString().trim().isEmpty) {
      final type = args.runtimeType;
      AppLogger.warning(
        'Expected a non-empty String argument for slug, but got type: $type with value: $args',
      );
      AppLogger.warning('Invalid slug argument: $args');
      return;
    }

    slug = args['slug'].toString().trim();

    fetchDetail(slug);
  }

  Future<void> fetchDetail(String sourceSlug) async {
    AppLogger.info('Fetching resource detail for slug: $sourceSlug');
    if (sourceSlug.trim().isEmpty) {
      AppLogger.warning('Slug is empty, skipping API call');
      return;
    }

    AppLogger.info('Valid slug provided, proceeding with API call');

    try {
      isLoading.value = true;
      errorMessage.value = null;
      AppLogger.info(
        'Starting API call to fetch resource detail for slug: $sourceSlug',
      );

      final detail = await _repository.getResourceDetail(sourceSlug);
      item.value = detail;

      AppLogger.api('Fetched resource detail:', data: detail);
    } catch (e) {
      errorMessage.value = 'Failed to load resource detail';
      AppLogger.error(
        'Error fetching resource detail for slug: $sourceSlug',
        error: e,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
