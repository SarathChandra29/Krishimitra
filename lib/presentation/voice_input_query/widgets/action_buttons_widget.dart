import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onReRecord;
  final VoidCallback onSubmit;
  final bool isSubmitEnabled;

  const ActionButtonsWidget({
    Key? key,
    required this.isVisible,
    required this.onReRecord,
    required this.onSubmit,
    required this.isSubmitEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isVisible ? 8.h : 0,
        child: isVisible
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Re-record button
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      child: OutlinedButton.icon(
                        onPressed: onReRecord,
                        icon: CustomIconWidget(
                          iconName: 'refresh',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 5.w,
                        ),
                        label: Text(
                          'మళ్లీ రికార్డ్ చేయండి',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: AppTheme.lightTheme.primaryColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Submit button
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      child: ElevatedButton.icon(
                        onPressed: isSubmitEnabled ? onSubmit : null,
                        icon: CustomIconWidget(
                          iconName: 'send',
                          color: isSubmitEnabled
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.38),
                          size: 5.w,
                        ),
                        label: Text(
                          'పంపండి',
                          style: AppTheme.lightTheme.textTheme.labelLarge
                              ?.copyWith(
                            color: isSubmitEnabled
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.38),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSubmitEnabled
                              ? AppTheme.lightTheme.primaryColor
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.12),
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: isSubmitEnabled ? 2 : 0,
                        ),
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
