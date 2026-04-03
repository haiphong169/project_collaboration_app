import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:project_collaboration_app/features/auth/data/repositories/session_provider_impl.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/add_conversation_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/check_existing_conversation_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/get_conversation_list_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/get_conversation_messages_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/send_message_usecase.dart';
import 'package:project_collaboration_app/features/project/data/data_sources/project_remote_data_source.dart';
import 'package:project_collaboration_app/features/project/data/data_sources/task_list_remote_data_source.dart';
import 'package:project_collaboration_app/features/project/data/data_sources/task_remote_data_source.dart';
import 'package:project_collaboration_app/features/project/data/repositories/project_repository_impl.dart';
import 'package:project_collaboration_app/features/project/data/repositories/task_list_repository_impl.dart';
import 'package:project_collaboration_app/features/project/data/repositories/task_repository_impl.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/project_repository.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_list_repository.dart';
import 'package:project_collaboration_app/features/project/domain/repositories/task_repository.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/project/add_project_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/project/get_projects_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/add_task_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/check_task_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task/get_task_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task_list/add_task_list_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task_list/archive_task_list_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task_list/delete_task_list_usecase.dart';
import 'package:project_collaboration_app/features/project/domain/usecases/task_list/get_task_lists_usecase.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/search_user_use_case.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_user_use_case.dart';
import 'package:project_collaboration_app/features/messaging/data/data_sources/conversation_remote_data_source.dart';
import 'package:project_collaboration_app/features/messaging/data/data_sources/message_remote_data_source.dart';
import 'package:project_collaboration_app/features/messaging/data/repositories/conversation_repository_impl.dart';
import 'package:project_collaboration_app/features/messaging/data/repositories/message_repository_impl.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/conversation_repository.dart';
import 'package:project_collaboration_app/features/messaging/domain/repositories/message_repository.dart';
import 'package:project_collaboration_app/features/user/data/data_sources/user_local_data_source.dart';
import 'package:project_collaboration_app/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:project_collaboration_app/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:project_collaboration_app/features/user/domain/repositories/user_repository.dart';

final repositoryProviders = [
  // data sources
  RepositoryProvider<AuthRemoteDataSource>(
    create: (context) => AuthRemoteDataSource(),
  ),
  RepositoryProvider<UserRemoteDataSource>(
    create: (context) => UserRemoteDataSource(),
  ),
  RepositoryProvider<UserLocalDataSource>(
    create: (context) => UserLocalDataSource(),
  ),
  RepositoryProvider<ConversationRemoteDataSource>(
    create: (context) => ConversationRemoteDataSource(),
  ),
  RepositoryProvider<MessageRemoteDataSource>(
    create: (context) => MessageRemoteDataSource(),
  ),
  RepositoryProvider<ProjectRemoteDataSource>(
    create: (context) => ProjectRemoteDataSource(),
  ),
  RepositoryProvider<TaskListRemoteDataSource>(
    create: (context) => TaskListRemoteDataSource(),
  ),
  RepositoryProvider<TaskRemoteDataSource>(
    create: (context) => TaskRemoteDataSource(),
  ),

  // repositories
  RepositoryProvider<AuthRepository>(
    create:
        (context) => AuthRepositoryImpl(
          authRemoteDataSource: context.read<AuthRemoteDataSource>(),
        ),
  ),

  RepositoryProvider<SessionProvider>(
    create:
        (context) => SessionProviderImpl(
          userLocalDataSource: context.read<UserLocalDataSource>(),
        )..init(),
  ),

  RepositoryProvider<UserRepository>(
    create:
        (context) => UserRepositoryImpl(
          userRemoteDataSource: context.read<UserRemoteDataSource>(),
        ),
  ),
  RepositoryProvider<ConversationRepository>(
    create:
        (context) => ConversationRepositoryImpl(
          conversationRemoteDataSource:
              context.read<ConversationRemoteDataSource>(),
        ),
  ),
  RepositoryProvider<MessageRepository>(
    create:
        (context) => MessageRepositoryImpl(
          messageRemoteDataSource: context.read<MessageRemoteDataSource>(),
        ),
  ),
  RepositoryProvider<ProjectRepository>(
    create:
        (context) =>
            ProjectRepositoryImpl(projectRemoteDataSource: context.read()),
  ),
  RepositoryProvider<TaskListRepository>(
    create:
        (context) =>
            TaskListRepositoryImpl(taskListRemoteDataSource: context.read()),
  ),
  RepositoryProvider<TaskRepository>(
    create:
        (context) => TaskRepositoryImpl(taskRemoteDataSource: context.read()),
  ),

  // use cases
  RepositoryProvider<LoginUseCase>(
    create:
        (context) => LoginUseCase(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<SignInWithGoogleUseCase>(
    create:
        (context) => SignInWithGoogleUseCase(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<RegisterUseCase>(
    create:
        (context) => RegisterUseCase(
          authRepository: context.read<AuthRepository>(),
          userRepository: context.read<UserRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<LogoutUseCase>(
    create:
        (context) => LogoutUseCase(
          authRepository: context.read<AuthRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<SearchUserUseCase>(
    create:
        (context) =>
            SearchUserUseCase(userRepository: context.read<UserRepository>()),
  ),
  RepositoryProvider<GetUserUseCase>(
    create:
        (context) =>
            GetUserUseCase(sessionProvider: context.read<SessionProvider>()),
  ),
  RepositoryProvider<AddConversationUsecase>(
    create:
        (context) => AddConversationUsecase(
          conversationRepository: context.read<ConversationRepository>(),
          messageRepository: context.read<MessageRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<SendMessageUsecase>(
    create:
        (context) => SendMessageUsecase(
          messageRepository: context.read<MessageRepository>(),
          conversationRepository: context.read<ConversationRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<GetConversationMessagesUsecase>(
    create:
        (context) => GetConversationMessagesUsecase(
          messageRepository: context.read<MessageRepository>(),
        ),
  ),
  RepositoryProvider<GetConversationListUsecase>(
    create:
        (context) => GetConversationListUsecase(
          conversationRepository: context.read<ConversationRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<CheckExistingConversationUsecase>(
    create:
        (context) => CheckExistingConversationUsecase(
          conversationRepository: context.read<ConversationRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<GetProjectsUseCase>(
    create:
        (context) => GetProjectsUseCase(
          projectRepository: context.read<ProjectRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<AddProjectUseCase>(
    create:
        (context) => AddProjectUseCase(
          projectRepository: context.read<ProjectRepository>(),
          sessionProvider: context.read<SessionProvider>(),
        ),
  ),
  RepositoryProvider<GetTaskListsUseCase>(
    create:
        (context) => GetTaskListsUseCase(
          taskListRepository: context.read<TaskListRepository>(),
        ),
  ),
  RepositoryProvider<AddTaskListUseCase>(
    create:
        (context) => AddTaskListUseCase(
          taskListRepository: context.read<TaskListRepository>(),
        ),
  ),
  RepositoryProvider<DeleteTaskListUseCase>(
    create:
        (context) => DeleteTaskListUseCase(
          taskListRepository: context.read<TaskListRepository>(),
        ),
  ),
  RepositoryProvider<AddTaskUseCase>(
    create:
        (context) =>
            AddTaskUseCase(taskRepository: context.read<TaskRepository>()),
  ),
  RepositoryProvider<CheckTaskUseCase>(
    create:
        (context) =>
            CheckTaskUseCase(taskRepository: context.read<TaskRepository>()),
  ),
  RepositoryProvider<ArchiveTaskListUseCase>(
    create:
        (context) => ArchiveTaskListUseCase(
          taskListRepository: context.read<TaskListRepository>(),
        ),
  ),
  RepositoryProvider<GetTaskUseCase>(
    create:
        (context) =>
            GetTaskUseCase(taskRepository: context.read<TaskRepository>()),
  ),
];

final dataSourceProviders = [];

final blocProviders = [];
