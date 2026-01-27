import 'package:flutter/material.dart';

class AnimatedNumberText extends StatefulWidget {
  final double endValue;
  final String prefix;
  final String suffix;
  final Duration duration;
  final TextStyle style;

  const AnimatedNumberText({
    super.key, // Added key for better widget tree handling
    required this.endValue,
    this.prefix = '',
    this.suffix = '',
    this.duration = const Duration(milliseconds: 1000),
    required this.style,
  });

  @override
  State<AnimatedNumberText> createState() => _AnimatedNumberTextState();
}

class _AnimatedNumberTextState extends State<AnimatedNumberText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    // Initial animation from 0 to endValue
    _animation = Tween<double>(begin: 0.0, end: widget.endValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedNumberText oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle updates (e.g. when the provider refreshes data)
    if (oldWidget.endValue != widget.endValue) {
      _animation = Tween<double>(begin: _animation.value, end: widget.endValue).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '${widget.prefix}${_animation.value.toStringAsFixed(2)}${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}