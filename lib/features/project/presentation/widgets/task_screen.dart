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
  late final TextEditingController _todoController;
  bool _isEditingDescription = false;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _todoController = TextEditingController();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _todoController.dispose();
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
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 16),
                child: Text(
                  'People working on this task',
                  style: textTheme.labelMedium,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 16),
                child: TextButton(
                  onPressed: () {
                    context.read<TaskCubit>().assignTaskToMyself(
                      widget.projectUid,
                      widget.taskListUid,
                      widget.taskUid,
                      model.assignees.contains(model.currentUser)
                          ? false
                          : true,
                    );
                  },
                  child: Text(
                    model.assignees.contains(model.currentUser)
                        ? 'Unassign myself'
                        : 'Assign myself',
                  ),
                ),
              ),
            ],
          ),
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
                  height: 75,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        model.assignees
                            .map(
                              (assignee) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  UserCircleAvatar(
                                    avatar: assignee.avatar,
                                    radius: 28,
                                  ),
                                  SizedBox(width: 16),
                                  Text(
                                    assignee.username,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Checklist', style: textTheme.labelMedium),
                SizedBox(height: 8),
                Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _todoController,
                            decoration: InputDecoration(
                              hintText: 'Add a todo',
                              border: InputBorder.none,
                            ),
                            onSubmitted: (value) {
                              if (value.trim().isEmpty) return;
                              context.read<TaskCubit>().addTodo(
                                widget.projectUid,
                                widget.taskListUid,
                                widget.taskUid,
                                value.trim(),
                              );
                              _todoController.clear();
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            final text = _todoController.text.trim();
                            if (text.isEmpty) return;
                            context.read<TaskCubit>().addTodo(
                              widget.projectUid,
                              widget.taskListUid,
                              widget.taskUid,
                              text,
                            );
                            _todoController.clear();
                          },
                          icon: Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Column(
                    children:
                        model.task.todos.map((todo) {
                          return ListTile(
                            leading: Checkbox(
                              value: todo.isCompleted,
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  context.read<TaskCubit>().checkTodo(
                                    widget.projectUid,
                                    widget.taskListUid,
                                    widget.taskUid,
                                    todo.uid,
                                    newValue,
                                  );
                                }
                              },
                            ),
                            title: Text(todo.name),
                            trailing: IconButton(
                              onPressed: () {
                                context.read<TaskCubit>().removeTodo(
                                  widget.projectUid,
                                  widget.taskListUid,
                                  widget.taskUid,
                                  todo.uid,
                                );
                              },
                              icon: Icon(Icons.delete_outline),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Container(
              color: colorScheme.surfaceContainerHighest,
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Due date', style: textTheme.labelLarge),
                subtitle: Text(
                  model.task.dueDate != null
                      ? '${model.task.dueDate!.day}/${model.task.dueDate!.month}/${model.task.dueDate!.year}${model.task.dueDate!.hour != 0 || model.task.dueDate!.minute != 0 ? ' ${model.task.dueDate!.hour.toString().padLeft(2, '0')}:${model.task.dueDate!.minute.toString().padLeft(2, '0')}' : ''}'
                      : 'No due date',
                ),
                trailing: TextButton.icon(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: model.task.dueDate ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        Duration(days: 365 * 5),
                      ),
                      lastDate: DateTime.now().add(Duration(days: 365 * 10)),
                    );
                    if (selectedDate == null) return;

                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime:
                          model.task.dueDate != null
                              ? TimeOfDay(
                                hour: model.task.dueDate!.hour,
                                minute: model.task.dueDate!.minute,
                              )
                              : TimeOfDay.now(),
                    );

                    final combined = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime?.hour ?? 0,
                      selectedTime?.minute ?? 0,
                    );

                    context.read<TaskCubit>().updateTaskDueDate(
                      widget.projectUid,
                      widget.taskListUid,
                      widget.taskUid,
                      combined,
                    );
                  },
                  icon: Icon(
                    model.task.dueDate != null ? Icons.edit : Icons.add,
                  ),
                  label: Text(model.task.dueDate != null ? 'Edit' : 'Add'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
