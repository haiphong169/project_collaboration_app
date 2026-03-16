import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/domain/abstract_repositories/auth_repository.dart';
import 'package:project_collaboration_app/routing/routes.dart';
import 'package:project_collaboration_app/ui/auth/login/view_models/login_view_model.dart';
import 'package:project_collaboration_app/ui/auth/login/widgets/login_screen.dart';
import 'package:project_collaboration_app/ui/auth/logout/view_models/logout_view_model.dart';
import 'package:project_collaboration_app/ui/auth/register/view_models/register_view_model.dart';
import 'package:project_collaboration_app/ui/auth/register/widgets/register_screen.dart';
import 'package:project_collaboration_app/ui/core/ui/bottom_nav_bar_screen.dart';
import 'package:project_collaboration_app/ui/home/widgets/home_screen.dart';
import 'package:project_collaboration_app/ui/inbox/widgets/inbox_screen.dart';
import 'package:project_collaboration_app/ui/messages/widgets/messages_screen.dart';
import 'package:project_collaboration_app/ui/profile/widgets/profile_screen.dart';
import 'package:provider/provider.dart';

GoRouter router(AuthRepository authRepository) {
  return GoRouter(
    initialLocation: Routes.home,
    redirect: _redirect,
    refreshListenable: authRepository,
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) {
          return LoginScreen(
            viewModel: LoginViewModel(authRepository: authRepository),
          );
        },
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) {
          return RegisterScreen(
            viewModel: RegisterViewModel(authRepository: authRepository),
          );
        },
      ),
      GoRoute(
        path: Routes.addProject,
        builder: (context, state) {
          // todo update
          return Placeholder();
        },
      ),
      GoRoute(
        path: '${Routes.project}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          // TODO update
          return Placeholder();
        },
      ),
      GoRoute(
        path: '${Routes.task}/:taskId',
        builder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          // TODO update
          return Placeholder();
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavBarScreen(child: child);
        },
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (context, state) {
              return HomeScreen();
            },
          ),
          GoRoute(
            path: Routes.messages,
            builder: (context, state) {
              return MessagesScreen();
            },
          ),
          GoRoute(
            path: Routes.inbox,
            builder: (context, state) {
              return InboxScreen();
            },
          ),
          GoRoute(
            path: Routes.profile,
            builder: (context, state) {
              return ProfileScreen(
                viewModel: LogoutViewModel(authRepository: authRepository),
              );
            },
          ),
        ],
      ),
    ],
  );
}

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn =
      state.matchedLocation == Routes.login ||
      state.matchedLocation == Routes.register;

  if (!loggedIn && !loggingIn) {
    return Routes.login;
  }

  if (loggedIn && loggingIn) {
    return Routes.home;
  }

  return null;
}
