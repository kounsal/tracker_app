import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../router/route_names.dart';
import '../../../../../utils/common/widgets/custom_button.dart';
import '../../../../../utils/theme/app_theme_constants.dart';
import '../../../../../utils/theme/theme.extension.dart';
import '../../provider/auth_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  void _handleLogout(BuildContext context, AuthProvider authProvider) async {
    await authProvider.logout();
    if (context.mounted) {
      context.go(RouteNames.loginPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingXL,
              vertical: 20.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                CircleAvatar(
                  radius: 50.r,
                  backgroundColor: context.colors.brandColor.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 50.w,
                    color: context.colors.brandColor,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  user?.name ?? 'Loading User...',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: 48.h),

                // Details Section
                Container(
                  padding: EdgeInsets.all(AppSizes.paddingM),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    border: Border.all(
                      color: context.colors.border.withOpacity(0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildProfileItem(
                        context,
                        Icons.email_outlined,
                        'Email',
                        user?.email ?? '-',
                      ),
                      Divider(color: context.colors.divider),
                      _buildProfileItem(
                        context,
                        Icons.numbers,
                        'User ID',
                        user?.id.toString() ?? '-',
                      ),
                    ],
                  ),
                ),

                const Spacer(),
                CustomButton(
                  text: 'Logout',
                  color: context.colors.error,
                  onPressed: () => _handleLogout(context, authProvider),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.colors.iconPrimary.withOpacity(0.6),
            size: AppSizes.iconSizeM,
          ),
          SizedBox(width: 16.w),
          Text(
            label,
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 14.sp,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: context.colors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
