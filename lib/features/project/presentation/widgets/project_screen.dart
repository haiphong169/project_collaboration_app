import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/config/routing/routes.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/project_screen_cubit.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({
    super.key,
    required this.projectName,
    required this.backgroundColorValue,
  });

  final String projectName;
  final int backgroundColorValue;

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  String _newTaskListName = '';
  bool _isAddingNewTaskList = false;
  String? _addingTaskListUid;
  String _newTaskName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(
        widget.backgroundColorValue,
      ).withValues(alpha: 0.6),
      appBar: _appBar(),
      body: BlocListener<ProjectScreenCubit, UiState<List<TaskList>>>(
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
        child: BlocBuilder<ProjectScreenCubit, UiState<List<TaskList>>>(
          builder: (context, state) {
            switch (state) {
              case Success(:final data):
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: SizedBox(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ..._buildTaskLists(data),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isAddingNewTaskList = true;
                              });
                            },
                            child: SizedBox(
                              width: 250,
                              height: 75,
                              child: Card(
                                color: Theme.of(context).colorScheme.surface,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child:
                                        _isAddingNewTaskList
                                            ? TextField(
                                              decoration: InputDecoration(
                                                fillColor:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.surface,
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.blue,
                                                        width: 2,
                                                      ),
                                                    ),
                                                contentPadding: EdgeInsets.zero,
                                                hintText: 'List name',
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  _newTaskListName = value;
                                                });
                                              },
                                            )
                                            : Icon(Icons.add),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
    if (_isAddingNewTaskList) {
      return AppBar(
        title: Text('Add list'),
        actions: [
          IconButton(
            onPressed:
                _newTaskListName.isEmpty
                    ? null
                    : () {
                      context.read<ProjectScreenCubit>().addTaskList(
                        _newTaskListName,
                      );
                      setState(() {
                        _newTaskListName = '';
                        _isAddingNewTaskList = false;
                      });
                    },
            icon: Icon(Icons.done),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            setState(() {
              _newTaskListName = '';
              _isAddingNewTaskList = false;
            });
          },
          icon: Icon(Icons.close),
        ),
        backgroundColor: Color(widget.backgroundColorValue),
      );
    } else if (_addingTaskListUid != null) {
      return AppBar(
        title: Text('Add task'),
        actions: [
          IconButton(
            onPressed:
                _newTaskName.isEmpty
                    ? null
                    : () {
                      context.read<ProjectScreenCubit>().addTask(
                        _addingTaskListUid!,
                        _newTaskName,
                      );
                      setState(() {
                        _addingTaskListUid = null;
                        _newTaskName = '';
                      });
                    },
            icon: Icon(Icons.check),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            setState(() {
              _newTaskName = '';
              _addingTaskListUid = null;
            });
          },
          icon: Icon(Icons.close),
        ),
      );
    } else {
      return AppBar(
        title: Text(widget.projectName),
        backgroundColor: Color(widget.backgroundColorValue),
        actions: [
          IconButton(
            icon: Icon(Icons.archive_outlined),
            onPressed: () {
              context.push(
                Routes.archiveWithId(
                  context.read<ProjectScreenCubit>().projectUid,
                ),
                extra: widget.backgroundColorValue,
              );
            },
          ),
        ],
      );
    }
  }

  List<Widget> _buildTaskLists(List<TaskList> taskLists) {
    final theme = Theme.of(context);

    return taskLists.map((taskList) {
      return SizedBox(
        width: 250,
        child: Card(
          color: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        taskList.name,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    _taskListOptionsButton(taskList),
                  ],
                ),
                taskList.taskHeaders.isEmpty
                    ? SizedBox()
                    : ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children:
                          taskList.taskHeaders.values
                              .map(
                                (header) => _taskHeader(header, taskList.uid),
                              )
                              .toList(),
                    ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child:
                      _addingTaskListUid != null &&
                              _addingTaskListUid == taskList.uid
                          ? TextField(
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.surface,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Task name',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _newTaskName = value;
                              });
                            },
                          )
                          : TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _addingTaskListUid = taskList.uid;
                              });
                            },
                            icon: Icon(Icons.add, size: 16, color: Colors.blue),
                            label: Text(
                              'Add task',
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _taskHeader(TaskHeader header, String taskListUid) {
    return Card(
      margin: const EdgeInsets.only(right: 16, bottom: 12),
      child: Row(
        children: [
          Checkbox(
            value: header.isCompleted,
            onChanged: (newValue) {
              context.read<ProjectScreenCubit>().checkTask(
                taskListUid,
                header.taskUid,
                newValue!,
              );
            },
            shape: CircleBorder(),
            checkColor: Colors.white,
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.green;
              }
              return Colors.transparent;
            }),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.push(
                  Routes.taskWithId(header.taskUid),
                  extra: {
                    'taskName': header.name,
                    'projectUid': context.read<ProjectScreenCubit>().projectUid,
                    'taskListUid': taskListUid,
                  },
                );
              },
              child: Text(header.name),
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskListOptionsButton(TaskList taskList) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'delete':
            context.read<ProjectScreenCubit>().deleteTaskList(taskList.uid);
            break;
          case 'archive':
            context.read<ProjectScreenCubit>().archiveTaskList(taskList.uid);
            break;
        }
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(value: 'delete', child: Text('Delete List')),
            PopupMenuItem(value: 'archive', child: Text('Archive List')),
          ],
    );
  }
}
