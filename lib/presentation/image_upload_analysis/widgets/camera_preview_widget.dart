import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController? cameraController;
  final bool isFlashOn;
  final VoidCallback onFlashToggle;
  final VoidCallback onCapture;
  final VoidCallback onGallery;

  const CameraPreviewWidget({
    Key? key,
    required this.cameraController,
    required this.isFlashOn,
    required this.onFlashToggle,
    required this.onCapture,
    required this.onGallery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.lightTheme.primaryColor,
              ),
              SizedBox(height: 2.h),
              Text(
                'Initializing Camera...',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Camera Preview
        Positioned.fill(
          child: CameraPreview(cameraController!),
        ),

        // Overlay guides for leaf positioning
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
            ),
            child: Center(
              child: Container(
                width: 70.w,
                height: 50.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Corner guides
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: AppTheme.lightTheme.primaryColor,
                                width: 3),
                            left: BorderSide(
                                color: AppTheme.lightTheme.primaryColor,
                                width: 3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                                color: AppTheme.lightTheme.primaryColor,
                                width: 3),
                            right: BorderSide(
                                color: AppTheme.lightTheme.primaryColor,
                                width: 3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: AppTheme.lightTheme.primaryColor,
                                width: 3),
                            left: BorderSide(
                                color: AppTheme.lightTheme.primaryColor,
                                width: 3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: AppTheme.lightTheme.primaryColor,
                                width: 3),
                            right: BorderSide(
                                color: AppTheme.lightTheme.primaryColor,
                                width: 3),
                          ),
                        ),
                      ),
                    ),
                    // Center instruction
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Position leaf within frame',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Top controls
        Positioned(
          top: 6.h,
          left: 4.w,
          right: 4.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),

              // Flash toggle
              GestureDetector(
                onTap: onFlashToggle,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: isFlashOn ? 'flash_on' : 'flash_off',
                    color: isFlashOn
                        ? AppTheme.lightTheme.primaryColor
                        : Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: 8.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Gallery button
              GestureDetector(
                onTap: onGallery,
                child: Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CustomIconWidget(
                    iconName: 'photo_library',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),

              // Capture button
              GestureDetector(
                onTap: onCapture,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),

              // Placeholder for symmetry
              SizedBox(width: 15.w),
            ],
          ),
        ),
      ],
    );
  }
}
