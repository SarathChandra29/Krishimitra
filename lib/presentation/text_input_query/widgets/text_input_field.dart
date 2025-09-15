import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TextInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function() onVoiceToText;
  final bool isLoading;
  final int maxLength;

  const TextInputField({
    Key? key,
    required this.controller,
    required this.onVoiceToText,
    this.isLoading = false,
    this.maxLength = 500,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isFocused
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: _isFocused ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  maxLines: 6,
                  minLines: 4,
                  maxLength: widget.maxLength,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        "మీ వ్యవసాయ సమస్య గురించి వివరంగా రాయండి...\nఉదాహరణ: నా టమాటో పంటలో ఆకులు వాడిపోతున్నాయి",
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(4.w),
                    counterText: "",
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: widget.isLoading ? null : widget.onVoiceToText,
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: widget.isLoading
                                ? AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.1)
                                : AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'mic',
                                color: widget.isLoading
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.5)
                                    : AppTheme.lightTheme.colorScheme.primary,
                                size: 18,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                "వాయిస్",
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: widget.isLoading
                                      ? AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.5)
                                      : AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "${widget.controller.text.length}/${widget.maxLength}",
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: widget.controller.text.length >
                                  widget.maxLength * 0.9
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
