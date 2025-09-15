import 'package:flutter/material.dart';

class AnimatedLogoWidget extends StatefulWidget {
  final VoidCallback onAnimationComplete;
  const AnimatedLogoWidget({Key? key, required this.onAnimationComplete}) : super(key: key);

  @override
  State<AnimatedLogoWidget> createState() => _AnimatedLogoWidgetState();
}

class _AnimatedLogoWidgetState extends State<AnimatedLogoWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward().whenComplete(widget.onAnimationComplete);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
      child: Image.asset(
        'assets/logo.png', // <-- Put your logo here
        width: 120,
        height: 120,
      ),
    );
  }
}
