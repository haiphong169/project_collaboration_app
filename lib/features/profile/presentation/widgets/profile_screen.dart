import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/core/ui/user_circle_avatar.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/auth/presentation/bloc/logout_cubit.dart';
import 'package:project_collaboration_app/features/user/presentation/bloc/user_cubit.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 60),
            BlocBuilder<UserCubit, UiState<User>>(
              bloc: context.read<UserCubit>(),
              builder: (context, state) {
                return switch (state) {
                  Loading<User>() => CircularProgressIndicator(),
                  Error<User>(:final message) => Text(message),
                  Success<User>(:final data) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      UserCircleAvatar(avatar: data.avatar),
                      SizedBox(height: 16),
                      Text(
                        data.username,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  Idle<User>() => SizedBox(),
                  _ => SizedBox(),
                };
              },
            ),
            SizedBox(height: 80),
            BlocBuilder<LogoutCubit, VoidUiState>(
              bloc: context.read<LogoutCubit>(),
              builder: (context, state) {
                final isLoading = state is Loading<void>;
                final isError = state is Error<void>;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap:
                          isLoading ? null : context.read<LogoutCubit>().logout,
                      child: Container(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                isLoading
                                    ? [CircularProgressIndicator()]
                                    : [
                                      Text(
                                        'Log out',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      ),
                                      Spacer(),
                                      Icon(Icons.logout),
                                    ],
                          ),
                        ),
                      ),
                    ),
                    if (isError) ...[
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(color: Colors.red),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
