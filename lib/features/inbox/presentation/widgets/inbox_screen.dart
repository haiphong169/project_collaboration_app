import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/inbox/presentation/bloc/inbox_cubit.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InboxCubit, UiState<List<Task>>>(
      listener: (context, state) {
        if (state is Error<List<Task>>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is Success<List<Task>>) {
          return _buildInboxList(context, state.data);
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _buildInboxList(BuildContext context, List<Task> inbox) {
    return ListView.builder(
      itemCount: inbox.length,
      itemBuilder: (context, index) {
        return Row(children: [Text(inbox[index].name)]);
      },
    );
  }
}
