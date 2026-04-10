import 'package:project_collaboration_app/features/messaging/data/models/conversation_model.dart';
import 'package:project_collaboration_app/features/messaging/data/models/message_model.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/project/data/models/project_model.dart';
import 'package:project_collaboration_app/features/project/data/models/task_list_model.dart';
import 'package:project_collaboration_app/features/project/data/models/task_model.dart';
import 'package:project_collaboration_app/features/project/domain/entities/project.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/features/user/data/models/user_model.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

extension UserMapper on User {
  UserModel toModel() {
    return UserModel(uid: uid, username: username, avatar: avatar.toModel());
  }
}

extension AvatarMapper on Avatar {
  AvatarModel toModel() {
    return AvatarModel(
      backgroundColorValue: backgroundColorValue,
      textColorValue: textColorValue,
      initials: initials,
    );
  }
}

extension MessageMapper on Message {
  MessageModel toModel() {
    return MessageModel(
      uid: uid,
      conversationUid: conversationUid,
      senderUid: senderUid,
      text: text,
      createdAt: createdAt,
    );
  }
}

extension ConversationMapper on Conversation {
  ConversationModel toModel() {
    return ConversationModel(
      uid: uid,
      participants: participants,
      lastMessage: lastMessage,
      lastMessageAt: lastMessageAt,
      lastMessageSenderUid: lastMessageSenderUid,
    );
  }
}

extension ProjectMapper on Project {
  ProjectModel toModel() {
    return ProjectModel(
      uid: uid,
      name: name,
      backgroundColorValue: backgroundColorValue,
      members: members,
      ownerUid: ownerUid,
    );
  }
}

extension TaskListMapper on TaskList {
  TaskListModel toModel() {
    return TaskListModel(
      uid: uid,
      projectUid: projectUid,
      name: name,
      isArchived: isArchived,
      taskHeaders: taskHeaders.map(
        (key, value) => MapEntry(key, value.toModel()),
      ),
    );
  }
}

extension TaskHeaderMapper on TaskHeader {
  TaskHeaderModel toModel() {
    return TaskHeaderModel(
      taskUid: taskUid,
      name: name,
      isCompleted: isCompleted,
    );
  }
}

extension TaskMapper on Task {
  TaskModel toModel() {
    return TaskModel(
      uid: uid,
      taskListUid: taskListUid,
      projectUid: projectUid,
      name: name,
      isCompleted: isCompleted,
      assignees: assignees,
    );
  }
}
