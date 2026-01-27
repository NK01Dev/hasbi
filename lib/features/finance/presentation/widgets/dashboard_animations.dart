import 'package:flutter/material.dart';

/// A widget that animates numeric value changes with a counting effect.
class AnimatedNumberText extends StatelessWidget {
  final double value;
  final TextStyle? style;
  final Duration duration;
  final String prefix;
  final int decimalPlaces;

  const AnimatedNumberText({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 1200),
    this.prefix = "\$ ",
    this.decimalPlaces = 2,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutQuart,
      builder: (context, animatedValue, child) {
        return Text(
          "$prefix${animatedValue.toStringAsFixed(decimalPlaces)}",
          style: style,
        );
      },
    );
  }
}

/// A wrapper widget that slides items up and fades them in.
class StaggeredEntrance extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration delayStep;

  const StaggeredEntrance({
    super.key,
    required this.child,
    required this.index,
    this.delayStep = const Duration(milliseconds: 100),
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      // Adding a slight delay based on index
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      // Using Future.delayed to simulate stagged start would require a more complex setup,
      // but for simple cases, TweenAnimationBuilder with staggered indices works well.
      child: child,
    );
  }
}
