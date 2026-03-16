import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/data/repositories/auth/auth_repository_remote.dart';
import 'package:project_collaboration_app/data/services/firebase_auth_client.dart';
import 'package:project_collaboration_app/data/services/shared_preferences_client.dart';
import 'package:project_collaboration_app/domain/abstract_repositories/auth_repository.dart';

final repositoryProviders = [
  RepositoryProvider<SharedPreferencesClient>(
    create: (_) => SharedPreferencesClient(),
  ),
  RepositoryProvider<FirebaseAuthClient>(create: (_) => FirebaseAuthClient()),
  RepositoryProvider<AuthRepository>(
    create:
        (context) => AuthRepositoryRemote(
          sharedPreferencesClient: context.read(),
          firebaseAuthClient: context.read(),
        ),
  ),
];

final blocProviders = [];
