import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/core/ui/user_circle_avatar.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/task_cubit.dart';
import 'package:project_collaboration_app/features/project/presentation/ui_models/task_ui_model.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    super.key,
    required this.taskName,
    required this.projectUid,
    required this.taskListUid,
    required this.taskUid,
  });
  final String taskName;
  final String projectUid;
  final String taskListUid;
  final String taskUid;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late final TextEditingController _descriptionController;
  bool _isEditingDescription = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, UiState<TaskUiModel>>(
      listener: (context, state) {
        _descriptionController.text = state.getData()?.task.description ?? '';
        if (state is Error<TaskUiModel>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is OnNavigationPop<TaskUiModel>) {
          context.pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.taskName),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<TaskCubit>().deleteTask(
                    widget.projectUid,
                    widget.taskListUid,
                    widget.taskUid,
                  );
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          body: Stack(
            children: [
              if (state is Success<TaskUiModel>) ...[
                _taskDetails(context, state.data),
              ] else if (state is Loading<TaskUiModel>) ...[
                state.data != null
                    ? _taskDetails(context, state.data!)
                    : SizedBox(),
                Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _taskDetails(BuildContext context, TaskUiModel model) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 32),
          Container(
            color: colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Checkbox(
                    value: model.task.isCompleted,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        context.read<TaskCubit>().checkTask(
                          widget.projectUid,
                          widget.taskListUid,
                          widget.taskUid,
                          newValue,
                        );
                      }
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
                  SizedBox(width: 16),
                  Text(
                    model.task.name,
                    style: textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Container(
            color: colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.short_text),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      onTap: () {
                        setState(() {
                          _isEditingDescription = true;
                        });
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        contentPadding: EdgeInsets.zero,
                        hint: Padding(
                          padding: const EdgeInsets.only(bottom: 48),
                          child: Text(
                            'Add task description',
                            style: textTheme.labelLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 48,
                    child:
                        _isEditingDescription
                            ? Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<TaskCubit>()
                                        .updateTaskDescription(
                                          widget.projectUid,
                                          widget.taskListUid,
                                          widget.taskUid,
                                          _descriptionController.text,
                                        );
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      _isEditingDescription = false;
                                    });
                                  },
                                  icon: Icon(Icons.check, color: Colors.green),
                                ),
                                SizedBox(height: 16),
                                IconButton(
                                  onPressed: () async {
                                    _descriptionController.text =
                                        model.task.description ?? '';
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      _isEditingDescription = false;
                                    });
                                  },
                                  icon: Icon(Icons.close),
                                  color: Colors.red,
                                ),
                              ],
                            )
                            : null,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 16),
              child: TextButton(
                onPressed: () {
                  context.read<TaskCubit>().assignTaskToMyself(
                    widget.projectUid,
                    widget.taskListUid,
                    widget.taskUid,
                    model.assignees.contains(model.currentUser) ? false : true,
                  );
                },
                child: Text(
                  model.assignees.contains(model.currentUser)
                      ? 'Unassign myself'
                      : 'Assign myself',
                ),
              ),
            ),
          ),
          Container(
            color: colorScheme.surfaceContainerHighest,
            child:
                model.assignees.isEmpty
                    ? Center(
                      child: SizedBox(
                        height: 100,
                        child: Center(child: Text('No assginees yet.')),
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        top: 16,
                        bottom: 16,
                      ),
                      child: SizedBox(
                        height: 200,
                        child: GridView.count(
                          crossAxisCount: 2,
                          padding: EdgeInsets.zero,
                          children:
                              model.assignees
                                  .map(
                                    (assignee) => Row(
                                      children: [
                                        UserCircleAvatar(
                                          avatar: assignee.avatar,
                                          radius: 32,
                                        ),
                                        SizedBox(width: 16),
                                        Text(
                                          assignee.username,
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
