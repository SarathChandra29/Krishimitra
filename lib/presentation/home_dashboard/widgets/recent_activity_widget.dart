import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentQueries;
  final VoidCallback onViewAll;

  const RecentActivityWidget({
    Key? key,
    required this.recentQueries,
    required this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ఇటీవలి కార్యకలాపాలు',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  'అన్నీ చూడండి',
                  style: GoogleFonts.openSans(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          recentQueries.isEmpty
              ? _buildEmptyState(theme)
              : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentQueries.length > 3 ? 3 : recentQueries.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final query = recentQueries[index];
              return _buildActivityItem(query, theme);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: Colors.black45,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'ఇంకా ప్రశ్నలు లేవు',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'మీ మొదటి ప్రశ్న అడగండి',
            style: GoogleFonts.openSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> query, ThemeData theme) {
    final String type = query['type'] as String;
    final String question = query['question'] as String;
    final String timestamp = query['timestamp'] as String;
    final String? imageUrl = query['imageUrl'] as String?;

    final Color typeColor = _getTypeColor(type, theme);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: imageUrl != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CustomImageWidget(
                  imageUrl: imageUrl,
                  width: 10.w,
                  height: 10.w,
                  fit: BoxFit.cover,
                ),
              )
                  : CustomIconWidget(
                iconName: _getTypeIcon(type),
                color: typeColor,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: GoogleFonts.openSans(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'access_time',
                      color: Colors.black38,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      timestamp,
                      style: GoogleFonts.openSans(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'arrow_forward_ios',
            color: Colors.black38,
            size: 16,
          ),
        ],
      ),
    );
  }

  String _getTypeIcon(String type) {
    switch (type) {
      case 'text':
        return 'text_fields';
      case 'voice':
        return 'mic';
      case 'image':
        return 'camera_alt';
      default:
        return 'help_outline';
    }
  }

  Color _getTypeColor(String type, ThemeData theme) {
    switch (type) {
      case 'text':
        return theme.colorScheme.primary;
      case 'voice':
        return Colors.deepPurple;
      case 'image':
        return Colors.green;
      default:
        return Colors.black54;
    }
  }
}
