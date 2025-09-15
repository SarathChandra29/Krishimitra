import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TranscriptionDisplayWidget extends StatelessWidget {
  final String transcribedText;
  final bool isVisible;

  const TranscriptionDisplayWidget({
    Key? key,
    required this.transcribedText,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 85.w,
        constraints: BoxConstraints(
          minHeight: isVisible ? 8.h : 0,
          maxHeight: 20.h,
        ),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isVisible
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'text_fields',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'మీ మాట:',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        transcribedText.isEmpty
                            ? 'మీ మాట ఇక్కడ కనిపిస్తుంది...'
                            : transcribedText,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: transcribedText.isEmpty
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
