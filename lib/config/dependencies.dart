import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:project_collaboration_app/features/user/data/data_sources/user_local_data_source.dart';
import 'package:project_collaboration_app/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:project_collaboration_app/features/auth/data/repositories/auth_repository_impl.dart';

import 'package:project_collaboration_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_user_use_case.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:project_collaboration_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart';

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
];

final dataSourceProviders = [];

// final useCaseProviders = [
//   RepositoryProvider(
//     create: (context) => LoginUseCase(authRepository: context.read()),
//   ),
//   RepositoryProvider(
//     create: (context) => LogoutUsecase(authRepository: context.read()),
//   ),
//   RepositoryProvider(
//     create: (context) => RegisterUseCase(authRepository: context.read()),
//   ),
//   RepositoryProvider(
//     create:
//         (context) => SignInWithGoogleUseCase(authRepository: context.read()),
//   ),
//   RepositoryProvider(
//     create: (context) => GetUserUseCase(authRepository: context.read()),
//   ),
// ];

final blocProviders = [];
