import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onStartQuerying;

  const EmptyStateWidget({
    Key? key,
    required this.onStartQuerying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Agricultural illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'agriculture',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),

            Text(
              'No Queries Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),

            Text(
              'Start asking questions about your crops, soil, weather, or farming techniques. Your AI assistant is ready to help!',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),

            ElevatedButton.icon(
              onPressed: onStartQuerying,
              icon: CustomIconWidget(
                iconName: 'chat',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 5.w,
              ),
              label: Text('Start Asking Questions'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Quick action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  icon: 'keyboard',
                  label: 'Text Query',
                  onTap: () =>
                      Navigator.pushNamed(context, '/text-input-query'),
                ),
                _buildQuickActionButton(
                  icon: 'mic',
                  label: 'Voice Query',
                  onTap: () =>
                      Navigator.pushNamed(context, '/voice-input-query'),
                ),
                _buildQuickActionButton(
                  icon: 'camera_alt',
                  label: 'Image Analysis',
                  onTap: () =>
                      Navigator.pushNamed(context, '/image-upload-analysis'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 6.w,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
