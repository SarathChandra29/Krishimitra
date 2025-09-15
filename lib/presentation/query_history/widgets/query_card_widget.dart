import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QueryCardWidget extends StatelessWidget {
  final Map<String, dynamic> queryData;
  final VoidCallback? onTap;
  final VoidCallback? onReAsk;
  final VoidCallback? onDelete;
  final bool isSelected;
  final VoidCallback? onLongPress;

  const QueryCardWidget({
    Key? key,
    required this.queryData,
    this.onTap,
    this.onReAsk,
    this.onDelete,
    this.isSelected = false,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final queryType = queryData['type'] as String? ?? 'text';
    final isBookmarked = queryData['isBookmarked'] as bool? ?? false;
    final timestamp = queryData['timestamp'] as DateTime? ?? DateTime.now();
    final query = queryData['query'] as String? ?? '';
    final response = queryData['response'] as String? ?? '';
    final location = queryData['location'] as String? ?? '';

    return Dismissible(
      key: Key(queryData['id'].toString()),
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'refresh',
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Re-ask',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'delete',
              color: Colors.white,
              size: 6.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Delete',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onReAsk?.call();
          return false;
        } else if (direction == DismissDirection.endToStart) {
          return await _showDeleteConfirmation(context);
        }
        return false;
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary, width: 2)
              : null,
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
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: _getQueryTypeColor(queryType)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: _getQueryTypeIcon(queryType),
                          color: _getQueryTypeColor(queryType),
                          size: 5.w,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatTimestamp(timestamp),
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (location.isNotEmpty) ...[
                              SizedBox(height: 0.5.h),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'location_on',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 3.5.w,
                                  ),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: Text(
                                      location,
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (isBookmarked)
                        CustomIconWidget(
                          iconName: 'star',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 5.w,
                        ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    query,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    response,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getQueryTypeIcon(String type) {
    switch (type) {
      case 'voice':
        return 'mic';
      case 'image':
        return 'camera_alt';
      default:
        return 'keyboard';
    }
  }

  Color _getQueryTypeColor(String type) {
    switch (type) {
      case 'voice':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'image':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete Query',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            content: Text(
              'Are you sure you want to delete this query? This action cannot be undone.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  onDelete?.call();
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
                child: Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
