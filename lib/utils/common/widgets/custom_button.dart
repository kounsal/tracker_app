import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../theme/app_theme_constants.dart';
import '../../theme/theme.extension.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? context.colors.brandColor;

    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: defaultColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
              ),
              child: _buildChild(context, defaultColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
                disabledBackgroundColor: defaultColor.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
                elevation: 0,
              ),
              child: _buildChild(context, context.colors.textOnBrand),
            ),
    );
  }

  Widget _buildChild(BuildContext context, Color textColor) {
    if (isLoading) {
      return SizedBox(
        height: 24.h,
        width: 24.h,
        child: CircularProgressIndicator(
          color: isOutlined
              ? context.colors.brandColor
              : context.colors.textOnBrand,
          strokeWidth: 2,
        ),
      );
    }

    return Text(
      text,
      style: TextStyle(
        color: isOutlined ? textColor : context.colors.textOnBrand,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
