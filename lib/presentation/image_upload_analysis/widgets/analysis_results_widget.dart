import 'dart:io';

import 'package:before_after/before_after.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnalysisResultsWidget extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic> analysisData;
  final VoidCallback onShare;
  final VoidCallback onSaveToHistory;

  const AnalysisResultsWidget({
    Key? key,
    required this.imagePath,
    required this.analysisData,
    required this.onShare,
    required this.onSaveToHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isHealthy = (analysisData['isHealthy'] as bool?) ?? false;
    final double confidence = (analysisData['confidence'] as double?) ?? 0.0;
    final String diagnosis =
        (analysisData['diagnosis'] as String?) ?? 'Unknown';
    final List<String> symptoms =
        List<String>.from(analysisData['symptoms'] ?? []);
    final List<String> treatments =
        List<String>.from(analysisData['treatments'] ?? []);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.lightTheme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Text(
                      'Analysis Results',
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                  ),
                  GestureDetector(
                    onTap: onShare,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Health status card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: isHealthy
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isHealthy ? Colors.green : Colors.red,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                  color: isHealthy ? Colors.green : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: CustomIconWidget(
                                  iconName:
                                      isHealthy ? 'check_circle' : 'error',
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isHealthy
                                          ? 'Healthy Leaf'
                                          : 'Disease Detected',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: isHealthy
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${(confidence * 100).toStringAsFixed(1)}% confidence',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (!isHealthy) ...[
                            SizedBox(height: 2.h),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Diagnosis:',
                                    style: AppTheme
                                        .lightTheme.textTheme.titleSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    diagnosis,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Before/After comparison
                    Text(
                      'Analysis Visualization',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BeforeAfter(
                          before: Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                          ),
                          after: Image.file(
                            File(imagePath),
                            fit: BoxFit.cover,
                            color: isHealthy
                                ? null
                                : Colors.red.withValues(alpha: 0.3),
                            colorBlendMode:
                                isHealthy ? null : BlendMode.overlay,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    if (!isHealthy && symptoms.isNotEmpty) ...[
                      // Symptoms section
                      Text(
                        'Identified Symptoms',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      ...symptoms
                          .map((symptom) => Container(
                                margin: EdgeInsets.only(bottom: 2.h),
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.orange.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'warning',
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Text(
                                        symptom,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),

                      SizedBox(height: 3.h),
                    ],

                    if (!isHealthy && treatments.isNotEmpty) ...[
                      // Treatment recommendations
                      Text(
                        'Recommended Treatments',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      ...treatments.asMap().entries.map((entry) {
                        int index = entry.key;
                        String treatment = entry.value;
                        return Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.cardColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${index + 1}',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  treatment,
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],

                    SizedBox(height: 4.h),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/home-dashboard'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('New Analysis'),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onSaveToHistory,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Save to History'),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}