import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _queryTypes = ['All', 'Text', 'Voice', 'Image'];
  final List<String> _dateRanges = [
    'All Time',
    'Today',
    'This Week',
    'This Month'
  ];
  final List<String> _cropTypes = [
    'All Crops',
    'Rice',
    'Cotton',
    'Sugarcane',
    'Maize',
    'Groundnut'
  ];
  final List<String> _severityLevels = [
    'All Levels',
    'Low',
    'Medium',
    'High',
    'Critical'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Queries',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    'Query Type',
                    _queryTypes,
                    _filters['queryType'] ?? 'All',
                    (value) => setState(() => _filters['queryType'] = value),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Date Range',
                    _dateRanges,
                    _filters['dateRange'] ?? 'All Time',
                    (value) => setState(() => _filters['dateRange'] = value),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Crop Type',
                    _cropTypes,
                    _filters['cropType'] ?? 'All Crops',
                    (value) => setState(() => _filters['cropType'] = value),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Issue Severity',
                    _severityLevels,
                    _filters['severity'] ?? 'All Levels',
                    (value) => setState(() => _filters['severity'] = value),
                  ),
                  SizedBox(height: 2.h),

                  // Bookmarked only toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bookmarked Only',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        value: _filters['bookmarkedOnly'] ?? false,
                        onChanged: (value) =>
                            setState(() => _filters['bookmarkedOnly'] = value),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    child: Text('Apply Filters'),
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

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return FilterChip(
              label: Text(
                option,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) => onChanged(option),
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              selectedColor: AppTheme.lightTheme.colorScheme.primary,
              checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'queryType': 'All',
        'dateRange': 'All Time',
        'cropType': 'All Crops',
        'severity': 'All Levels',
        'bookmarkedOnly': false,
      };
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }
}
