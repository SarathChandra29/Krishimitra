import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnalysisLoadingWidget extends StatefulWidget {
  final String imagePath;

  const AnalysisLoadingWidget({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<AnalysisLoadingWidget> createState() => _AnalysisLoadingWidgetState();
}

class _AnalysisLoadingWidgetState extends State<AnalysisLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.lightTheme.scaffoldBackgroundColor,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.cardColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Analyzing Leaf',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated analysis icon
                  AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value * 2 * 3.14159,
                        child: AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.primaryColor
                                      .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.lightTheme.primaryColor,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: CustomIconWidget(
                                    iconName: 'eco',
                                    color: AppTheme.lightTheme.primaryColor,
                                    size: 48,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Progress indicator
                  Container(
                    width: 60.w,
                    child: LinearProgressIndicator(
                      backgroundColor: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Status text
                  Text(
                    'AI is analyzing your leaf image...',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    'This may take a few moments',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 4.h),

                  // Processing steps
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      children: [
                        _buildProcessingStep(
                          'Uploading image',
                          true,
                          CustomIconWidget(
                            iconName: 'cloud_upload',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        _buildProcessingStep(
                          'Detecting leaf features',
                          true,
                          CustomIconWidget(
                            iconName: 'search',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 20,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        _buildProcessingStep(
                          'Analyzing health status',
                          false,
                          CustomIconWidget(
                            iconName: 'analytics',
                            color: Colors.grey[400]!,
                            size: 20,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        _buildProcessingStep(
                          'Generating recommendations',
                          false,
                          CustomIconWidget(
                            iconName: 'lightbulb',
                            color: Colors.grey[400]!,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingStep(String title, bool isCompleted, Widget icon) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                : Colors.grey[100],
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted
                  ? AppTheme.lightTheme.primaryColor
                  : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Center(child: icon),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: isCompleted
                  ? AppTheme.lightTheme.primaryColor
                  : Colors.grey[600],
              fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
        if (isCompleted)
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.lightTheme.primaryColor,
            size: 20,
          ),
      ],
    );
  }
}
