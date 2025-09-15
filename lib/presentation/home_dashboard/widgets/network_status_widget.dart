import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/custom_icon_widget.dart';

class NetworkStatusWidget extends StatelessWidget {
  final bool isConnected;
  final bool isAiServiceAvailable;

  const NetworkStatusWidget({
    Key? key,
    required this.isConnected,
    required this.isAiServiceAvailable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isConnected && isAiServiceAvailable) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _getStatusIcon(),
            color: _getStatusColor(),
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusTitle(),
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(),
                  ),
                ),
                if (_getStatusSubtitle().isNotEmpty) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    _getStatusSubtitle(),
                    style: GoogleFonts.openSans(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (!isConnected) {
      return Colors.red;
    } else if (!isAiServiceAvailable) {
      return Colors.orange;
    }
    return Colors.green;
  }

  String _getStatusIcon() {
    if (!isConnected) {
      return 'wifi_off';
    } else if (!isAiServiceAvailable) {
      return 'warning';
    }
    return 'wifi';
  }

  String _getStatusTitle() {
    if (!isConnected) {
      return 'ఇంటర్నెట్ కనెక్షన్ లేదు';
    } else if (!isAiServiceAvailable) {
      return 'AI సేవ అందుబాటులో లేదు';
    }
    return 'కనెక్ట్ అయ్యింది';
  }

  String _getStatusSubtitle() {
    if (!isConnected) {
      return 'కొన్ని ఫీచర్లు పరిమితంగా ఉంటాయి';
    } else if (!isAiServiceAvailable) {
      return 'దయచేసి కొద్దిసేపు తర్వాత ప్రయత్నించండి';
    }
    return '';
  }
}
