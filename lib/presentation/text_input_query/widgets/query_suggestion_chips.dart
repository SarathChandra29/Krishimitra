import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuerySuggestionChips extends StatelessWidget {
  final Function(String) onSuggestionTap;

  const QuerySuggestionChips({
    Key? key,
    required this.onSuggestionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> suggestions = [
      {
        "text": "పంట వ్యాధులు",
        "query": "నా పంటలో ఆకులు పసుపు రంగులోకి మారుతున్నాయి, ఏమి చేయాలి?",
        "icon": "bug_report"
      },
      {
        "text": "ఎరువులు",
        "query": "ఏ రకమైన ఎరువులు వాడాలి మరియు ఎప్పుడు వేయాలి?",
        "icon": "eco"
      },
      {
        "text": "వాతావరణం",
        "query": "వర్షాకాలంలో పంటలను ఎలా కాపాడాలి?",
        "icon": "cloud"
      },
      {
        "text": "కీటకాలు",
        "query": "కీటకాల నుండి పంటలను ఎలా రక్షించాలి?",
        "icon": "pest_control"
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "సాధారణ ప్రశ్నలు",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: suggestions.map((suggestion) {
              return GestureDetector(
                onTap: () => onSuggestionTap(suggestion["query"] as String),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow
                            .withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: suggestion["icon"] as String,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        suggestion["text"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
