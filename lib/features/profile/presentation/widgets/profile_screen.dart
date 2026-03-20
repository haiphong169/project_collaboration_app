import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<UserCubit, UiState<User>>(
              bloc: context.read<UserCubit>(),
              builder: (context, state) {
                return switch (state) {
                  Loading<User>() => CircularProgressIndicator(),
                  Error<User>(:final message) => Text(message),
                  Success<User>(:final data) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: Color(
                          data.avatar.backgroundColorValue,
                        ),
                        child: Text(
                          state.data.avatar.initials,
                          style: TextStyle(
                            fontSize: 32,
                            color: Color(state.data.avatar.textColorValue),
                          ),
                        ),
                      ),
                      Text(data.username),
                    ],
                  ),
                  Idle<User>() => SizedBox(),
                };
              },
            ),
            BlocBuilder<LogoutCubit, VoidUiState>(
              bloc: context.read<LogoutCubit>(),
              builder: (context, state) {
                final isLoading = state is Loading<void>;
                final isError = state is Error<void>;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed:
                          isLoading ? null : context.read<LogoutCubit>().logout,
                      child:
                          isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Logout'),
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
