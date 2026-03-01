import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../router/route_names.dart';
import '../../../../utils/theme/app_theme_constants.dart';
import '../../../../utils/theme/theme.extension.dart';
import '../provider/task_provider.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus =
      ''; // '' for all, 'PENDING', 'IN_PROGRESS', 'COMPLETED'
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks(refresh: true);
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<TaskProvider>();
      if (!provider.isLoading &&
          provider.pagination != null &&
          _currentPage < provider.pagination!.totalPages) {
        _currentPage++;
        _loadTasks();
      }
    }
  }

  Future<void> _loadTasks({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
    }
    await context.read<TaskProvider>().getTasks(
      page: _currentPage,
      limit: 10,
      status: _selectedStatus.isNotEmpty ? _selectedStatus : null,
      search: _searchController.text.isNotEmpty ? _searchController.text : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          'Tasks',
          style: TextStyle(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: context.colors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: context.colors.brandColor),
            onPressed: () {
              context.push(RouteNames.createTaskPath).then((_) {
                _loadTasks(refresh: true);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter & Search Section
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingM),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: AppSizes.inputHeight,
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(AppSizes.radiusM),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: context.colors.textSecondary),
                        SizedBox(width: AppSizes.paddingS),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(color: context.colors.textPrimary),
                            decoration: InputDecoration(
                              hintText: 'Search tasks...',
                              hintStyle: TextStyle(
                                color: context.colors.textSecondary,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) {
                              _loadTasks(refresh: true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.paddingS),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.filter_list,
                    color: context.colors.brandColor,
                  ),
                  onSelected: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                    _loadTasks(refresh: true);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: '', child: Text('All')),
                    const PopupMenuItem(
                      value: 'PENDING',
                      child: Text('Pending'),
                    ),
                    const PopupMenuItem(
                      value: 'IN_PROGRESS',
                      child: Text('In Progress'),
                    ),
                    const PopupMenuItem(
                      value: 'COMPLETED',
                      child: Text('Completed'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // List Section
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.tasks.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.tasks.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => _loadTasks(refresh: true),
                    color: context.colors.brandColor,
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                            child: Text(
                              'No tasks found.',
                              style: TextStyle(
                                color: context.colors.textSecondary,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => _loadTasks(refresh: true),
                  color: context.colors.brandColor,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    padding: EdgeInsets.all(AppSizes.paddingM),
                    itemCount:
                        provider.tasks.length + (provider.isLoading ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: AppSizes.cardSpacing),
                    itemBuilder: (context, index) {
                      if (index == provider.tasks.length) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final task = provider.tasks[index];
                      return GestureDetector(
                        onTap: () {
                          context
                              .push('${RouteNames.taskDetailPath}/${task.id}')
                              .then((_) {
                                _loadTasks(refresh: true);
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.all(AppSizes.paddingM),
                          decoration: BoxDecoration(
                            color: context.colors.surface,
                            borderRadius: BorderRadius.circular(
                              AppSizes.radiusL,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: TextStyle(
                                        color: context.colors.textPrimary,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: AppSizes.paddingXS),
                                    Text(
                                      task.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: context.colors.textSecondary,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: AppSizes.paddingM),
                              _buildStatusBadge(context, task.status),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
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
        horizontal: AppSizes.paddingS,
        vertical: AppSizes.paddingXS,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(
          color: textColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
