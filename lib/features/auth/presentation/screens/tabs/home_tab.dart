import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/theme/app_theme_constants.dart';
import '../../../../../utils/theme/theme.extension.dart';

import '../../provider/auth_provider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userName = authProvider.user?.name ?? 'User';

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingXL,
              vertical: 20.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $userName!',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Here's your overview",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: 32.h),
                // Dashboard content can go here
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dashboard_outlined,
                          size: 64.w,
                          color: context.colors.divider,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Your dashboard will appear here',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
