import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:project_collaboration_app/features/user/data/data_sources/user_local_data_source.dart';
import 'package:project_collaboration_app/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:project_collaboration_app/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/features/user/data/repositories/user_repository_impl.dart';
import 'package:project_collaboration_app/features/user/domain/repositories/user_repository.dart';

final authRemoteDataSource = AuthRemoteDataSource();
final userRemoteDataSource = UserRemoteDataSource();
final userLocalDataSource = UserLocalDataSource();

final repositoryProviders = [
  RepositoryProvider.value(value: authRemoteDataSource),
  RepositoryProvider.value(value: userRemoteDataSource),
  RepositoryProvider.value(value: userLocalDataSource),

  RepositoryProvider<AuthRepository>(
    create:
        (context) => AuthRepositoryImpl(
          authRemoteDataSource: authRemoteDataSource,
          userRemoteDataSource: userRemoteDataSource,
          userLocalDataSource: userLocalDataSource,
        ),
  ),

  RepositoryProvider<UserRepository>(
    create:
        (context) =>
            UserRepositoryImpl(userRemoteDataSource: userRemoteDataSource),
  ),
];

final dataSourceProviders = [];

final blocProviders = [];
