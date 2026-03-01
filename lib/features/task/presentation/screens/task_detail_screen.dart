import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../utils/common/widgets/custom_button.dart';
import '../../../../router/route_names.dart';
import '../../../../utils/theme/app_theme_constants.dart';
import '../../../../utils/theme/theme.extension.dart';
import '../../data/model/task_params.dart';
import '../provider/task_provider.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, child) {
        final task = provider.tasks.firstWhere(
          (t) => t.id.toString() == taskId,
        );

        return Scaffold(
          backgroundColor: context.colors.background,
          appBar: AppBar(
            title: Text(
              'Task Details',
              style: TextStyle(
                color: context.colors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: context.colors.surface,
            iconTheme: IconThemeData(color: context.colors.textPrimary),
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.edit, color: context.colors.brandColor),
                onPressed: () {
                  context.push('${RouteNames.editTaskPath}/$taskId');
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: context.colors.error),
                onPressed: () => _confirmDelete(context, provider),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSizes.paddingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      _buildStatusBadge(context, task.status),
                      SizedBox(height: AppSizes.paddingL),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: context.colors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.sectionSpacing),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: AppSizes.paddingS),
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: context.colors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingL,
                  vertical: AppSizes.paddingL,
                ),
                child: CustomButton(
                  text: 'Change Status',
                  isLoading: provider.isLoading,
                  onPressed: () {
                    _showStatusBottomSheet(context, provider, task.status);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStatusBottomSheet(
    BuildContext context,
    TaskProvider provider,
    String currentStatus,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXL),
        ),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.all(AppSizes.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Change Status',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.paddingL),
              _buildStatusOption(
                context,
                bottomSheetContext,
                provider,
                'PENDING',
                currentStatus,
              ),
              SizedBox(height: AppSizes.paddingS),
              _buildStatusOption(
                context,
                bottomSheetContext,
                provider,
                'IN_PROGRESS',
                currentStatus,
              ),
              SizedBox(height: AppSizes.paddingS),
              _buildStatusOption(
                context,
                bottomSheetContext,
                provider,
                'COMPLETED',
                currentStatus,
              ),
              SizedBox(height: AppSizes.paddingL),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption(
    BuildContext context,
    BuildContext bottomSheetContext,
    TaskProvider provider,
    String status,
    String currentStatus,
  ) {
    final isSelected = status == currentStatus;

    return InkWell(
      onTap: () async {
        Navigator.pop(bottomSheetContext); // close bottom sheet
        if (!isSelected) {
          final task = provider.tasks.firstWhere(
            (t) => t.id.toString() == taskId,
          );
          await provider.updateTask(
            taskId,
            TaskParams(
              title: task.title,
              description: task.description,
              status: status,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(AppSizes.radiusM),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSizes.paddingM,
          horizontal: AppSizes.paddingL,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          color: isSelected
              ? context.colors.brandColor.withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? context.colors.brandColor
                : context.colors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              status.replaceAll('_', ' '),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? context.colors.brandColor
                    : context.colors.textPrimary,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: context.colors.brandColor),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color bgColor;
    Color textColor;
    switch (status) {
      case 'COMPLETED':
        bgColor = context.colors.success.withOpacity(0.1);
        textColor = context.colors.success;
        break;
      case 'IN_PROGRESS':
        bgColor = context.colors.warning.withOpacity(0.1);
        textColor = context.colors.warning;
        break;
      case 'PENDING':
      default:
        bgColor = context.colors.textSecondary.withOpacity(0.1);
        textColor = context.colors.textSecondary;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.paddingM,
        vertical: AppSizes.paddingS,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(
          color: textColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, TaskProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Task',
          style: TextStyle(color: context.colors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to delete this task?',
          style: TextStyle(color: context.colors.textSecondary),
        ),
        backgroundColor: context.colors.surface,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.colors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.deleteTask(taskId);
              if (success && context.mounted) {
                context.pop();
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: context.colors.error),
            ),
          ),
        ],
      ),
    );
  }
}
