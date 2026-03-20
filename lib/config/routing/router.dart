import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/features/messaging/presentation/widgets/message_screen.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_user_use_case.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:project_collaboration_app/features/auth/presentation/bloc/login_cubit.dart';
import 'package:project_collaboration_app/features/auth/presentation/bloc/logout_cubit.dart';
import 'package:project_collaboration_app/features/auth/presentation/bloc/register_cubit.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/search_user_use_case.dart';
import 'package:project_collaboration_app/features/user/presentation/bloc/search_user_bloc.dart';
import 'package:project_collaboration_app/features/user/presentation/bloc/user_cubit.dart';
import 'package:project_collaboration_app/config/routing/routes.dart';
import 'package:project_collaboration_app/features/auth/presentation/widgets/login_screen.dart';
import 'package:project_collaboration_app/features/auth/presentation/widgets/register_screen.dart';
import 'package:project_collaboration_app/core/ui/bottom_nav_bar_screen.dart';
import 'package:project_collaboration_app/features/profile/presentation/widgets/profile_screen.dart';
import 'package:project_collaboration_app/features/user/presentation/widgets/user_search_screen.dart';

GoRouter router(AuthRepository authRepository) {
  return GoRouter(
    initialLocation: Routes.home,
    redirect: _redirect,
    refreshListenable: authRepository,
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) {
          return BlocProvider(
            create:
                (context) => LoginCubit(
                  loginUseCase: LoginUseCase(authRepository: authRepository),
                  signInWithGoogleUseCase: SignInWithGoogleUseCase(
                    authRepository: authRepository,
                  ),
                ),
            child: LoginScreen(),
          );
        },
      ),
      GoRoute(
        path: Routes.register,
        builder: (context, state) {
          return BlocProvider(
            create:
                (context) => RegisterCubit(
                  registerUseCase: RegisterUseCase(
                    authRepository: authRepository,
                  ),
                  signInWithGoogleUseCase: SignInWithGoogleUseCase(
                    authRepository: authRepository,
                  ),
                ),
            child: RegisterScreen(),
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
      GoRoute(
        path: Routes.userSearch,
        builder: (context, state) {
          return BlocProvider(
            create:
                (context) => SearchUserBloc(
                  searchUserUseCase: SearchUserUseCase(
                    userRepository: context.read(),
                  ),
                ),
            child: UserSearchScreen(),
          );
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
              // TODO update
              return Placeholder();
            },
          ),
          GoRoute(
            path: Routes.messages,
            builder: (context, state) {
              return BlocProvider(
                create:
                    (context) => SearchUserBloc(
                      searchUserUseCase: SearchUserUseCase(
                        userRepository: context.read(),
                      ),
                    ),
                child: MessageScreen(),
              );
            },
          ),
          GoRoute(
            path: Routes.inbox,
            builder: (context, state) {
              // TODO update
              return Placeholder();
            },
          ),
          GoRoute(
            path: Routes.profile,
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create:
                        (context) => UserCubit(
                          getUserUseCase: GetUserUseCase(
                            authRepository: authRepository,
                          ),
                        )..fetchUser(),
                  ),
                  BlocProvider(
                    create:
                        (context) => LogoutCubit(
                          logoutUseCase: LogoutUsecase(
                            authRepository: authRepository,
                          ),
                        ),
                  ),
                ],
                child: ProfileScreen(),
              );
            },
          ),
        ],
      ),
    ],
  );
}

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final currentUser = await context.read<AuthRepository>().user;
  final loggingIn =
      state.matchedLocation == Routes.login ||
      state.matchedLocation == Routes.register;

  if (currentUser == null && !loggingIn) {
    return Routes.login;
  }

  if (currentUser != null && loggingIn) {
    return Routes.home;
  }

  return null;
}
