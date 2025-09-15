import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AiResponseWidget extends StatefulWidget {
  final String responseText;
  final bool isVisible;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onReplay;

  const AiResponseWidget({
    Key? key,
    required this.responseText,
    required this.isVisible,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onReplay,
  }) : super(key: key);

  @override
  State<AiResponseWidget> createState() => _AiResponseWidgetState();
}

class _AiResponseWidgetState extends State<AiResponseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(AiResponseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.forward();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _slideAnimation.value) * 10.h),
          child: Opacity(
            opacity: _slideAnimation.value,
            child: widget.isVisible
                ? Container(
                    width: 90.w,
                    constraints: BoxConstraints(
                      maxHeight: 40.h,
                    ),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.shadow,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header with AI icon
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: 'psychology',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 6.w,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'కృషిమిత్ర సలహా:',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        // Response text
                        Flexible(
                          child: SingleChildScrollView(
                            child: Text(
                              widget.responseText,
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onSurface,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        // Audio controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Play/Pause button
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: IconButton(
                                onPressed: widget.onPlayPause,
                                icon: CustomIconWidget(
                                  iconName:
                                      widget.isPlaying ? 'pause' : 'play_arrow',
                                  color: AppTheme.lightTheme.primaryColor,
                                  size: 6.w,
                                ),
                                padding: EdgeInsets.all(3.w),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            // Replay button
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: IconButton(
                                onPressed: widget.onReplay,
                                icon: CustomIconWidget(
                                  iconName: 'replay',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 6.w,
                                ),
                                padding: EdgeInsets.all(3.w),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
