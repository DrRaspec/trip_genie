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
              _TripGenieMark(),
              SizedBox(width: 8),
              Text(
                'TripGenie',
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

class _TripGenieMark extends StatelessWidget {
  const _TripGenieMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 31,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFF3264FF),
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 13,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF3264FF),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 2,
            child: Container(
              width: 13,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
