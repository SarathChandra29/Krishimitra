import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoadingAnimationWidget extends StatefulWidget {
  final bool isVisible;

  const LoadingAnimationWidget({
    Key? key,
    required this.isVisible,
  }) : super(key: key);

  @override
  State<LoadingAnimationWidget> createState() => _LoadingAnimationWidgetState();
}

class _LoadingAnimationWidgetState extends State<LoadingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(LoadingAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _rotationController.repeat();
      _scaleController.repeat(reverse: true);
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _rotationController.stop();
      _scaleController.stop();
      _rotationController.reset();
      _scaleController.reset();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: widget.isVisible
          ? Container(
              width: 90.w,
              height: 25.h,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated agricultural icon
                  AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Transform.rotate(
                              angle: _rotationAnimation.value * 2 * 3.14159,
                              child: Container(
                                width: 15.w,
                                height: 15.w,
                                decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.tertiary
                                      .withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: CustomIconWidget(
                                    iconName: 'agriculture',
                                    color: AppTheme
                                        .lightTheme.colorScheme.tertiary,
                                    size: 8.w,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 3.h),
                  // Loading text
                  Text(
                    'కృషిమిత్ర మీ ప్రశ్నను విశ్లేషిస్తోంది...',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  // Progress indicator
                  SizedBox(
                    width: 60.w,
                    child: LinearProgressIndicator(
                      backgroundColor: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'దయచేసి వేచి ఉండండి...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
