import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ImagePreviewWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onRetake;
  final VoidCallback onAnalyze;
  final VoidCallback onCrop;

  const ImagePreviewWidget({
    Key? key,
    required this.imagePath,
    required this.onRetake,
    required this.onAnalyze,
    required this.onCrop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Column(
        children: [
          // Top bar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 2.h,
              left: 4.w,
              right: 4.w,
              bottom: 2.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onRetake,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                Text(
                  'Preview',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: onCrop,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'crop',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Image preview
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
          ),

          // Instructions
          Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Text(
                  'Make sure the leaf is clearly visible and well-lit',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Good lighting',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Clear focus',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRetake,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white, width: 2),
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'camera_alt',
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Retake',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: onAnalyze,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'analytics',
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Analyze Leaf',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
