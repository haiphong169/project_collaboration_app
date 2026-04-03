import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/archive_screen_cubit.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key, required this.backgroundColorValue});
  final int backgroundColorValue;

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(
        widget.backgroundColorValue,
      ).withValues(alpha: 0.6),
      appBar: _appBar(),
      body: BlocListener<ArchiveScreenCubit, UiState<List<TaskList>>>(
        listener: (context, state) {
          if (state is Error<List<TaskList>>) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ArchiveScreenCubit, UiState<List<TaskList>>>(
          builder: (context, state) {
            switch (state) {
              case Success<List<TaskList>>():
                final taskLists = state.data;
                if (taskLists.isEmpty) {
                  return Center(child: Text('No archived lists'));
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
                  child: ListView.builder(
                    itemCount: taskLists.length,
                    itemBuilder: (context, index) {
                      final taskList = taskLists[index];
                      return Card(
                        color:
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                        child: ListTile(
                          title: Text(taskList.name),
                          subtitle: Text(
                            '${taskList.taskHeaders.length} task(s)',
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ArchiveScreenCubit>()
                                  .restoreTaskList(taskList.uid);
                            },
                            child: Text('Restore'),
                          ),
                        ),
                      );
                    },
                  ),
                );
              case Loading():
                return Center(child: CircularProgressIndicator());
              default:
                return SizedBox();
            }
          },
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Archived Lists'),
      backgroundColor: Color(widget.backgroundColorValue),
    );
  }
}
