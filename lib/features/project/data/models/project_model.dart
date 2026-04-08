import 'package:hive/hive.dart';
import 'package:project_collaboration_app/features/project/domain/entities/project.dart';

part 'project_model.g.dart';

@HiveType(typeId: 4)
class ProjectModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final int backgroundColorValue;
  @HiveField(3)
  final List<String> members;
  @HiveField(4)
  final String ownerUid;

  const ProjectModel({
    required this.uid,
    required this.name,
    required this.backgroundColorValue,
    required this.members,
    required this.ownerUid,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> map, String uid) {
    return ProjectModel(
      uid: uid,
      name: map['name'] as String,
      backgroundColorValue: map['backgroundColorValue'] as int,
      members: List<String>.from(map['members'] as List<dynamic>),
      ownerUid: map['ownerUid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'backgroundColorValue': backgroundColorValue,
      'members': members,
      'ownerUid': ownerUid,
    };
  }

  Project toEntity() {
    return Project(
      uid: uid,
      name: name,
      backgroundColorValue: backgroundColorValue,
      members: members,
      ownerUid: ownerUid,
    );
  }
}
