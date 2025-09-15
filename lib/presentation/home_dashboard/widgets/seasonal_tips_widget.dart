import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/custom_icon_widget.dart';

class SeasonalTipsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> tips;

  const SeasonalTipsWidget({
    Key? key,
    required this.tips,
  }) : super(key: key);

  @override
  State<SeasonalTipsWidget> createState() => _SeasonalTipsWidgetState();
}

class _SeasonalTipsWidgetState extends State<SeasonalTipsWidget> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tips.isEmpty) return const SizedBox.shrink();

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
                'రుతు సలహాలు',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (widget.tips.length > 1)
                Row(
                  children: List.generate(
                    widget.tips.length,
                        (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? theme.colorScheme.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 20.h,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: widget.tips.length,
              itemBuilder: (context, index) {
                final tip = widget.tips[index];
                return _buildTipCard(tip, theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(Map<String, dynamic> tip, ThemeData theme) {
    final String title = tip['title'] as String;
    final String description = tip['description'] as String;
    final String iconName = tip['icon'] as String;
    final String category = tip['category'] as String;

    final Color accent = theme.colorScheme.secondary;

    return Container(
      margin: EdgeInsets.only(right: 2.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withOpacity(0.1),
            accent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: accent,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: GoogleFonts.openSans(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: accent,
                      ),
                    ),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Text(
              description,
              style: GoogleFonts.openSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
