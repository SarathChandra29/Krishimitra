import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AiResponseCard extends StatefulWidget {
  final String response;
  final DateTime timestamp;
  final Function() onTextToSpeech;
  final Function() onShare;
  final bool isPlaying;

  const AiResponseCard({
    Key? key,
    required this.response,
    required this.timestamp,
    required this.onTextToSpeech,
    required this.onShare,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  State<AiResponseCard> createState() => _AiResponseCardState();
}

class _AiResponseCardState extends State<AiResponseCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return "ఇప్పుడే";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes} నిమిషాల క్రితం";
    } else if (difference.inDays < 1) {
      return "${difference.inHours} గంటల క్రితం";
    } else {
      return "${timestamp.day}/${timestamp.month}/${timestamp.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Card(
        elevation: 4,
        shadowColor:
            AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.colorScheme.surface,
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'psychology',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "కృషి మిత్ర సలహా",
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _formatTimestamp(widget.timestamp),
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleExpanded,
                      child: AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: Duration(milliseconds: 300),
                        child: CustomIconWidget(
                          iconName: 'expand_more',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              AnimatedBuilder(
                animation: _expandAnimation,
                builder: (context, child) {
                  return Container(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.response,
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            height: 1.6,
                          ),
                          maxLines: _isExpanded ? null : 3,
                          overflow: _isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                        if (!_isExpanded && widget.response.length > 150) ...[
                          SizedBox(height: 1.h),
                          GestureDetector(
                            onTap: _toggleExpanded,
                            child: Text(
                              "మరింత చదవండి...",
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 2.h),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: widget.onTextToSpeech,
                                icon: CustomIconWidget(
                                  iconName:
                                      widget.isPlaying ? 'stop' : 'volume_up',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 18,
                                ),
                                label: Text(
                                  widget.isPlaying ? "ఆపండి" : "వినండి",
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  padding:
                                      EdgeInsets.symmetric(vertical: 1.5.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: widget.onShare,
                                icon: CustomIconWidget(
                                  iconName: 'share',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 18,
                                ),
                                label: Text(
                                  "షేర్ చేయండి",
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 1.5.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
