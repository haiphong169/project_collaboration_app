import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:project_collaboration_app/features/auth/data/repositories/session_provider_impl.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
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

final authRemoteDataSource = AuthRemoteDataSource();
final userRemoteDataSource = UserRemoteDataSource();
final userLocalDataSource = UserLocalDataSource();
final conversationRemoteDataSource = ConversationRemoteDataSource();
final messageRemoteDataSource = MessageRemoteDataSource();

final repositoryProviders = [
  RepositoryProvider<AuthRepository>(
    create:
        (context) =>
            AuthRepositoryImpl(authRemoteDataSource: authRemoteDataSource),
  ),

  RepositoryProvider<SessionProvider>(
    create:
        (context) =>
            SessionProviderImpl(userLocalDataSource: userLocalDataSource)
              ..init(),
  ),

  RepositoryProvider<UserRepository>(
    create:
        (context) =>
            UserRepositoryImpl(userRemoteDataSource: userRemoteDataSource),
  ),
  RepositoryProvider<ConversationRepository>(
    create:
        (context) => ConversationRepositoryImpl(
          conversationRemoteDataSource: conversationRemoteDataSource,
        ),
  ),
  RepositoryProvider<MessageRepository>(
    create:
        (context) => MessageRepositoryImpl(
          messageRemoteDataSource: messageRemoteDataSource,
        ),
  ),
];

final dataSourceProviders = [];

final blocProviders = [];
