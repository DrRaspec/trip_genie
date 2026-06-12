import 'package:flutter/material.dart';

class RecordingWave extends StatelessWidget {
  const RecordingWave({
    super.key,
    required this.values,
    this.color = const Color(0xFF2F5BFF),
    this.height = 32,
  });

  final List<double> values;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const barWidth = 3.0;
          const barGap = 3.0;

          final maxBars = (constraints.maxWidth / (barWidth + barGap))
              .floor()
              .clamp(1, 1000);

          final visibleValues = values.length > maxBars
              ? values.sublist(values.length - maxBars)
              : values;

          final missingBars = maxBars - visibleValues.length;

          final displayValues = [
            ...List<double>.filled(missingBars.clamp(0, maxBars), 0.08),
            ...visibleValues,
          ];

          return ClipRect(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: displayValues.map((value) {
                final normalized = value.clamp(0.08, 1.0);
                final barHeight = 5 + (normalized * (height - 6));

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 90),
                  curve: Curves.easeOut,
                  width: barWidth,
                  height: barHeight,
                  margin: const EdgeInsets.symmetric(horizontal: barGap / 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(99),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
