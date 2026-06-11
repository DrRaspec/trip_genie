import 'dart:async';

import 'package:ai_chat_bot/app/routes/app_routes.dart';
import 'package:app_links/app_links.dart';
import 'package:get/get.dart';

class DeepLinkService extends GetxService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<DeepLinkService> init() async {
    // App opened from killed/closed state
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }

    // App already running/background
    _sub = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (error) {
        // Optional: log error
      },
    );

    return this;
  }

  void _handleDeepLink(Uri uri) {
    // Example:
    // tripgenie://resource/phnom-penh-to-siem-reap-bus

    if (uri.scheme != 'tripgenie') return;

    if (uri.host == 'resource') {
      final slug = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;

      if (slug == null || slug.isEmpty) return;

      Get.toNamed(AppRoutes.sourceDetail, arguments: {'slug': slug});

      return;
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
