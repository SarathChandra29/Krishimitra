import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 8.h,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: 'home',
                label: 'Home',
                route: '/home-dashboard',
                context: context,
              ),
              _buildNavItem(
                index: 1,
                icon: 'keyboard',
                label: 'Text',
                route: '/text-input-query',
                context: context,
              ),
              _buildNavItem(
                index: 2,
                icon: 'mic',
                label: 'Voice',
                route: '/voice-input-query',
                context: context,
              ),
              _buildNavItem(
                index: 3,
                icon: 'camera_alt',
                label: 'Image',
                route: '/image-upload-analysis',
                context: context,
              ),
              _buildNavItem(
                index: 4,
                icon: 'history',
                label: 'History',
                route: '/query-history',
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String label,
    required String route,
    required BuildContext context,
  }) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isSelected) {
              Navigator.pushReplacementNamed(context, route);
            }
            onTap(index);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(1.5.w),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: CustomIconWidget(
                    iconName: icon,
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
