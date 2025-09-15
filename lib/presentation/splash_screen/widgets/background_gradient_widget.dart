import 'package:flutter/material.dart';

class BackgroundGradientWidget extends StatelessWidget {
  const BackgroundGradientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
        ),
      ),
    );
  }
}
