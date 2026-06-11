import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppSnackbarType { info, success, warning, error }

class AppSnackbar {
  AppSnackbar._();

  static void show({
    required String title,
    required String message,
    AppSnackbarType type = AppSnackbarType.info,
    Duration duration = const Duration(seconds: 3),
    bool isDismissible = true,
    bool showIcon = true,
  }) {
    final colors = _colorsFor(type);

    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.rawSnackbar(
      titleText: const SizedBox.shrink(),
      messageText: _GlassSnackbarContent(
        title: title,
        message: message,
        icon: _iconFor(type),
        colors: colors,
        showIcon: showIcon,
      ),
      backgroundColor: Colors.transparent,
      borderColor: Colors.transparent,
      borderWidth: 0,
      boxShadows: const [],
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      snackPosition: SnackPosition.BOTTOM,
      duration: duration,
      isDismissible: isDismissible,
      shouldIconPulse: false,
      animationDuration: const Duration(milliseconds: 350),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }

  static void offline() {
    show(
      title: 'No internet connection',
      message: 'Some actions may not work until you are back online.',
      type: AppSnackbarType.warning,
      duration: const Duration(days: 1),
      isDismissible: false,
    );
  }

  static void online() {
    show(
      title: 'Back online',
      message: 'Connection restored.',
      type: AppSnackbarType.success,
      duration: const Duration(seconds: 2),
    );
  }

  static IconData _iconFor(AppSnackbarType type) {
    return switch (type) {
      AppSnackbarType.info => Icons.info_outline_rounded,
      AppSnackbarType.success => Icons.check_circle_outline_rounded,
      AppSnackbarType.warning => Icons.wifi_off_rounded,
      AppSnackbarType.error => Icons.error_outline_rounded,
    };
  }

  static _SnackbarColors _colorsFor(AppSnackbarType type) {
    return switch (type) {
      AppSnackbarType.info => const _SnackbarColors(
        accent: Color(0xFF3B82F6),
        border: Color(0xFF93C5FD),
      ),
      AppSnackbarType.success => const _SnackbarColors(
        accent: Color(0xFF10B981),
        border: Color(0xFF6EE7B7),
      ),
      AppSnackbarType.warning => const _SnackbarColors(
        accent: Color(0xFFF59E0B),
        border: Color(0xFFFCD34D),
      ),
      AppSnackbarType.error => const _SnackbarColors(
        accent: Color(0xFFEF4444),
        border: Color(0xFFFCA5A5),
      ),
    };
  }
}

class _GlassSnackbarContent extends StatelessWidget {
  const _GlassSnackbarContent({
    required this.title,
    required this.message,
    required this.icon,
    required this.colors,
    required this.showIcon,
  });

  final String title;
  final String message;
  final IconData icon;
  final _SnackbarColors colors;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark ? Colors.white : const Color(0xFF111827);

    final messageColor = isDark
        ? Colors.white.withValues(alpha: 0.78)
        : const Color(0xFF374151).withValues(alpha: 0.86);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: isDark
                ? Colors.black.withValues(alpha: 0.58)
                : Colors.white.withValues(alpha: 0.74),
            border: Border.all(
              color: colors.border.withValues(alpha: isDark ? 0.45 : 0.75),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.36 : 0.18),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 4,
                  margin: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: colors.accent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      showIcon ? 14 : 16,
                      14,
                      16,
                      14,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (showIcon) ...[
                          Icon(icon, color: colors.accent, size: 22),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                message,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: messageColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SnackbarColors {
  const _SnackbarColors({required this.accent, required this.border});

  final Color accent;
  final Color border;
}
