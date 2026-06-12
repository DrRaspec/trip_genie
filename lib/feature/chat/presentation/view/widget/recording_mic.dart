import 'package:flutter/material.dart';

class RecordingMicButton extends StatefulWidget {
  final bool isListening;
  final VoidCallback onStart;
  final VoidCallback onStop;

  const RecordingMicButton({
    super.key,
    required this.isListening,
    required this.onStart,
    required this.onStop,
  });

  @override
  State<RecordingMicButton> createState() => _RecordingMicButtonState();
}

class _RecordingMicButtonState extends State<RecordingMicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    if (widget.isListening) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant RecordingMicButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isListening && !_animationController.isAnimating) {
      _animationController.repeat(reverse: true);
    }

    if (!widget.isListening && _animationController.isAnimating) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (_) => widget.onStart(),
        onLongPressEnd: (_) => widget.onStop(),
        onLongPressCancel: widget.onStop,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final value = _animationController.value;

            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (widget.isListening)
                  Container(
                    width: 50 + (value * 18),
                    height: 50 + (value * 18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF111827).withValues(alpha: 0.08),
                    ),
                  ),

                if (widget.isListening)
                  Container(
                    width: 42 + (value * 10),
                    height: 42 + (value * 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF111827).withValues(alpha: 0.12),
                    ),
                  ),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isListening
                        ? const Color(0xFF111827)
                        : Colors.transparent,
                  ),
                  child: Icon(
                    Icons.mic_none_rounded,
                    color: widget.isListening
                        ? Colors.white
                        : const Color(0xFF111827),
                    size: 30,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
