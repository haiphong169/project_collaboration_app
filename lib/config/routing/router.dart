import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/inbox/presentation/widgets/inbox_screen.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/conversation/add_conversation_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/message/get_conversation_messages_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/message/send_message_usecase.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_event.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/conversation_bloc.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/message_screen_cubit.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/mock_conversation_bloc.dart';
import 'package:project_collaboration_app/features/messaging/presentation/widgets/conversation_screen.dart';
import 'package:project_collaboration_app/features/messaging/presentation/widgets/message_screen.dart';
import 'package:project_collaboration_app/features/messaging/presentation/widgets/mock_conversation_screen.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/add_project_cubit.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/archive_screen_cubit.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/home_screen_cubit.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/project_screen_cubit.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/task_cubit.dart';
import 'package:project_collaboration_app/features/project/presentation/widgets/add_project_screen.dart';
import 'package:project_collaboration_app/features/project/presentation/widgets/archive_screen.dart';
import 'package:project_collaboration_app/features/project/presentation/widgets/home_screen.dart';
import 'package:project_collaboration_app/features/project/presentation/widgets/project_screen.dart';
import 'package:project_collaboration_app/features/project/presentation/widgets/task_screen.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_user_use_case.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:project_collaboration_app/features/auth/presentation/bloc/login_cubit.dart';
import 'package:project_collaboration_app/features/auth/presentation/bloc/logout_cubit.dart';
import 'package:project_collaboration_app/features/auth/presentation/bloc/register_cubit.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_users_by_uids_usecase.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/search_user_use_case.dart';
import 'package:project_collaboration_app/features/user/presentation/bloc/search_user_bloc.dart';
import 'package:project_collaboration_app/features/user/presentation/bloc/user_cubit.dart';
import 'package:project_collaboration_app/config/routing/routes.dart';
import 'package:project_collaboration_app/features/auth/presentation/widgets/login_screen.dart';
import 'package:project_collaboration_app/features/auth/presentation/widgets/register_screen.dart';
import 'package:project_collaboration_app/core/ui/bottom_nav_bar_screen.dart';
import 'package:project_collaboration_app/features/profile/presentation/widgets/profile_screen.dart';
import 'package:project_collaboration_app/features/user/presentation/widgets/user_search_screen.dart';

GoRouter router(SessionListenable sessionListenable) {
  return GoRouter(
    initialLocation: Routes.home,
    redirect: (context, state) {
      final currentUser = context.read<SessionProvider>().user;
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
    },
    refreshListenable: sessionListenable,
    routes: [
      GoRoute(
        path: Routes.login,
        builder: (context, state) {
          return BlocProvider(
            create:
                (context) => LoginCubit(
                  loginUseCase: context.read<LoginUseCase>(),
                  signInWithGoogleUseCase:
                      context.read<SignInWithGoogleUseCase>(),
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
                  registerUseCase: context.read<RegisterUseCase>(),
                  signInWithGoogleUseCase:
                      context.read<SignInWithGoogleUseCase>(),
                ),
            child: RegisterScreen(),
          );
        },
      ),
      GoRoute(
        path: Routes.addProject,
        builder: (context, state) {
          return BlocProvider(
            create:
                (context) => AddProjectCubit(addProjectUseCase: context.read()),
            child: AddProjectScreen(),
          );
        },
      ),
      GoRoute(
        path: '${Routes.project}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final extra =
              GoRouterState.of(context).extra! as Map<String, dynamic>;
          final projectName = extra['projectName'] as String;
          final backgroundColorValue = extra['backgroundColorValue'] as int;
          return BlocProvider(
            create:
                (context) => ProjectScreenCubit(
                  getTaskListUseCase: context.read(),
                  addTaskListUseCase: context.read(),
                  deleteTaskListUseCase: context.read(),
                  addTaskUseCase: context.read(),
                  checkTaskUseCase: context.read(),
                  archiveTaskListUseCase: context.read(),
                  projectUid: id,
                )..fetchTaskLists(),
            child: ProjectScreen(
              projectName: projectName,
              backgroundColorValue: backgroundColorValue,
            ),
          );
        },
      ),
      GoRoute(
        path: '${Routes.archive}/:projectId',
        builder: (context, state) {
          final projectId = state.pathParameters['projectId']!;
          return BlocProvider(
            create:
                (context) => ArchiveScreenCubit(
                  getTaskListUseCase: context.read(),
                  archiveTaskListUseCase: context.read(),
                  projectUid: projectId,
                )..fetchArchivedTaskLists(),
            child: ArchiveScreen(backgroundColorValue: state.extra as int),
          );
        },
      ),
      GoRoute(
        path: '${Routes.task}/:taskId',
        builder: (context, state) {
          final taskId = state.pathParameters['taskId']!;
          final extra =
              GoRouterState.of(context).extra! as Map<String, dynamic>;
          return BlocProvider(
            create:
                (context) => TaskCubit(
                  getTaskUseCase: context.read(),
                  checkTaskUseCase: context.read(),
                  deleteTaskUseCase: context.read(),
                  projectUid: extra['projectUid'] as String,
                  taskListUid: extra['taskListUid'] as String,
                  taskUid: taskId,
                )..fetchTask(),
            child: TaskScreen(taskName: extra['taskName'] as String),
          );
        },
      ),
      // GoRoute(
      //   path: '${Routes.mockConversation}/:partnerId',
      //   builder: (context, state) {
      //     final partnerId = state.pathParameters['partnerId']!;
      //     return BlocProvider(
      //       create:
      //           (context) => MockConversationBloc(
      //             partnerId: partnerId,
      //             addConversationUseCase:
      //                 context.read<AddConversationUsecase>(),
      //             sendMessageUseCase: context.read<SendMessageUsecase>(),
      //           ),
      //       child: MockConversationScreen(),
      //     );
      //   },
      // ),
      GoRoute(
        path: '${Routes.conversation}/:conversationId',
        builder: (context, state) {
          final conversationId = state.pathParameters['conversationId']!;
          final partnerUid = GoRouterState.of(context).extra! as String;
          return BlocProvider(
            create:
                (context) => ConversationBloc(
                  conversationId: conversationId,
                  getConversationMessagesUsecase:
                      context.read<GetConversationMessagesUsecase>(),
                  sendMessageUsecase: context.read<SendMessageUsecase>(),
                  getUsersByUids: context.read<GetUsersByUidsUseCase>(),
                  sessionProvider: context.read<SessionProvider>(),
                  partnerUid: partnerUid,
                )..add(Initialization()),
            child: ConversationScreen(),
          );
        },
      ),
      GoRoute(
        path: Routes.userSearch,
        builder: (context, state) {
          final origin = state.extra as String;
          return BlocProvider(
            create:
                (context) => SearchUserBloc(
                  searchUserUseCase: context.read<SearchUserUseCase>(),
                  checkExistingConversationUseCase: context.read(),
                  origin: origin,
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
              return BlocProvider(
                create:
                    (context) =>
                        HomeScreenCubit(getProjectsUseCase: context.read())
                          ..fetchProjects(),
                child: HomeScreen(),
              );
            },
          ),
          GoRoute(
            path: Routes.messages,
            builder: (context, state) {
              return BlocProvider(
                create:
                    (context) => MessageScreenCubit(
                      getConversationPreviewsUseCase: context.read(),
                    )..fetchConversations(),
                child: MessageScreen(),
              );
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
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create:
                        (context) => UserCubit(
                          getUserUseCase: context.read<GetUserUseCase>(),
                        )..fetchUser(),
                  ),
                  BlocProvider(
                    create:
                        (context) => LogoutCubit(
                          logoutUseCase: context.read<LogoutUseCase>(),
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

class SessionListenable extends ChangeNotifier {
  final SessionProvider sessionProvider;
  late final StreamSubscription _sub;

  SessionListenable(this.sessionProvider) {
    _sub = sessionProvider.sessionStream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
