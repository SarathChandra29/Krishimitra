import 'package:flutter/material.dart';

class RetryButtonWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final bool isVisible;

  const RetryButtonWidget({
    super.key,
    required this.onRetry,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return ElevatedButton(
      onPressed: onRetry,
      child: const Text('Retry'),
    );
  }
}
