import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../utils/common/widgets/custom_button.dart';
import '../../../../utils/common/widgets/custom_text_field.dart';
import '../../../../utils/theme/app_theme_constants.dart';
import '../../../../utils/theme/theme.extension.dart';
import '../../data/model/task_params.dart';
import '../provider/task_provider.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;

  const EditTaskScreen({super.key, required this.taskId});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final task = context.read<TaskProvider>().tasks.firstWhere(
        (t) => t.id.toString() == widget.taskId,
      );
      _titleController.text = task.title;
      _descController.text = task.description;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      final task = context.read<TaskProvider>().tasks.firstWhere(
        (t) => t.id.toString() == widget.taskId,
      );
      final success = await context.read<TaskProvider>().updateTask(
        widget.taskId,
        TaskParams(
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          status: task.status, // preserve existing status
        ),
      );
      if (success && mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          'Edit Task',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: context.colors.surface,
        iconTheme: IconThemeData(color: context.colors.textPrimary),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingXL,
            vertical: AppSizes.paddingL,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSizes.paddingM),
                CustomTextField(
                  label: 'Title',
                  hintText: 'e.g., Learn Flutter',
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppSizes.sectionSpacing),
                CustomTextField(
                  label: 'Description',
                  hintText: 'Enter task description',
                  controller: _descController,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 48.h),
                Consumer<TaskProvider>(
                  builder: (context, provider, child) {
                    return CustomButton(
                      text: 'Update Task',
                      isLoading: provider.isLoading,
                      onPressed: _handleUpdate,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
