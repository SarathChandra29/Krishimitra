import 'package:flutter/material.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final String loadingText;
  final bool isVisible;

  const LoadingIndicatorWidget({
    super.key,
    required this.loadingText,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Column(
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        Text(
          loadingText,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }
}
