import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(108);

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _KhReviewAIIcon(),
              SizedBox(width: 8),
              Text(
                'KhReviewAI',
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
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
          onPressed: () {},
          icon: const Icon(Icons.volume_off_outlined, size: 34),
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
    return Icon(
      Icons.smart_toy_rounded,
      size: 36,
      color: const Color(0xFF111827),
    );
  }
}
