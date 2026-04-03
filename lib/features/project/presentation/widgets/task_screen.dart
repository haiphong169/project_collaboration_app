import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/task_cubit.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key, required this.taskName});
  final String taskName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(taskName)),
      body: BlocListener<TaskCubit, UiState<Task>>(
        listener: (context, state) {
          if (state is Error<Task>) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<TaskCubit, UiState<Task>>(
          builder: (context, state) {
            switch (state) {
              case Success<Task>():
                final task = state.data;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 32),
                      Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Checkbox(
                                splashRadius: 32,
                                value: task.isCompleted,
                                onChanged: (newValue) {
                                  if (newValue != null) {
                                    context.read<TaskCubit>().checkTask(
                                      newValue,
                                    );
                                  }
                                },
                                shape: CircleBorder(),
                                checkColor: Colors.white,
                                fillColor: WidgetStateProperty.resolveWith((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.green;
                                  }
                                  return Colors.transparent;
                                }),
                              ),
                              SizedBox(width: 16),
                              Text(
                                task.name,
                                style: textTheme.titleLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              case Loading<Task>():
                return Center(child: CircularProgressIndicator());
              default:
                return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
