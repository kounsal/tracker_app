import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/home_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/task/presentation/screens/create_task_screen.dart';
import '../features/task/presentation/screens/edit_task_screen.dart';
import '../features/task/presentation/screens/task_detail_screen.dart';
import '../features/task/presentation/screens/task_list_screen.dart';
import '../utils/common/screens/splash_screen.dart';
import '../utils/common/widgets/common_functions.dart';
import 'navigationn_arguments.dart';
import 'route_names.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: RouteNames.splashPath,
    routes: [
      GoRoute(
        path: RouteNames.splashPath,
        name: RouteNames.splashPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.loginPath,
        name: RouteNames.loginPath,

        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.registerPath,
        name: RouteNames.registerPath,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.homePath,
        name: RouteNames.homePath,
        builder: (context, state) {
          final args = state.extra as HomeArguments?;
          return HomeScreen(
            initialTab: args?.initialTab,
            refreshData: args?.refreshData,
          );
        },
      ),
      GoRoute(
        path: RouteNames.taskListPath,
        name: RouteNames.taskListPath,
        builder: (context, state) => const TaskListScreen(),
      ),
      GoRoute(
        path: RouteNames.createTaskPath,
        name: RouteNames.createTaskPath,
        builder: (context, state) => const CreateTaskScreen(),
      ),
      GoRoute(
        path: '${RouteNames.taskDetailPath}/:id',
        name: RouteNames.taskDetailPath,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TaskDetailScreen(taskId: id);
        },
      ),
      GoRoute(
        path: '${RouteNames.editTaskPath}/:id',
        name: RouteNames.editTaskPath,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EditTaskScreen(taskId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.matchedLocation}')),
    ),
  );
}
