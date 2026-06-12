import 'package:ai_chat_bot/feature/chat/presentation/view_model/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(108);

  @override
  Widget build(BuildContext context) {
    final controller = ChatViewModel.instance;

    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF111827),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: preferredSize.height,
      leadingWidth: 68,
      leading: IconButton(
        tooltip: 'Close',
        onPressed: () {},
        icon: const Icon(Icons.close_rounded, size: 36),
      ),
      title: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _KhReviewAIIcon(),
          SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'DeepThink',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down_rounded, size: 24),
            ],
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          tooltip: 'Mute',
          onPressed: () => controller.toggleMute(),
          icon: Obx(() {
            return Icon(
              controller.isMuted.value
                  ? Icons.volume_off_rounded
                  : Icons.volume_up_rounded,
              size: 34,
            );
          }),
        ),
        IconButton(
          tooltip: 'More',
          onPressed: () {},
          icon: const Icon(Icons.more_horiz_rounded, size: 34),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}

class _KhReviewAIIcon extends StatelessWidget {
  const _KhReviewAIIcon();

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/common/ll-3.png', height: 36);
  }
}
