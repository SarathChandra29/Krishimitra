import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecordingButtonWidget extends StatefulWidget {
  final bool isRecording;
  final bool isProcessing;
  final VoidCallback onTap;

  const RecordingButtonWidget({
    Key? key,
    required this.isRecording,
    required this.isProcessing,
    required this.onTap,
  }) : super(key: key);

  @override
  State<RecordingButtonWidget> createState() => _RecordingButtonWidgetState();
}

class _RecordingButtonWidgetState extends State<RecordingButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(RecordingButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _pulseController.repeat(reverse: true);
      _rippleController.repeat();
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _pulseController.stop();
      _rippleController.stop();
      _pulseController.reset();
      _rippleController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  Color _getButtonColor() {
    if (widget.isProcessing) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (widget.isRecording) {
      return AppTheme.lightTheme.colorScheme.error;
    } else {
      return AppTheme.lightTheme.primaryColor;
    }
  }

  String _getIconName() {
    if (widget.isProcessing) {
      return 'hourglass_empty';
    } else if (widget.isRecording) {
      return 'stop';
    } else {
      return 'mic';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isProcessing ? null : widget.onTap,
      child: Container(
        width: 20.w,
        height: 20.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ripple effect for recording state
            if (widget.isRecording)
              AnimatedBuilder(
                animation: _rippleAnimation,
                builder: (context, child) {
                  return Container(
                    width: 20.w * (1 + _rippleAnimation.value * 0.5),
                    height: 20.w * (1 + _rippleAnimation.value * 0.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _getButtonColor().withValues(
                          alpha: 1 - _rippleAnimation.value,
                        ),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
            // Main button with pulse animation
            AnimatedBuilder(
              animation: widget.isRecording
                  ? _pulseAnimation
                  : const AlwaysStoppedAnimation(1.0),
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isRecording ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getButtonColor(),
                      boxShadow: [
                        BoxShadow(
                          color: _getButtonColor().withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: widget.isProcessing
                        ? Center(
                            child: SizedBox(
                              width: 6.w,
                              height: 6.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onTertiary,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: CustomIconWidget(
                              iconName: _getIconName(),
                              color: widget.isRecording
                                  ? AppTheme.lightTheme.colorScheme.onError
                                  : AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 8.w,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
