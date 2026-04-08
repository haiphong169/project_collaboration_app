import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String uid;
  final String name;
  final int backgroundColorValue;
  final List<String> members;
  final String ownerUid;

  const Project({
    required this.uid,
    required this.name,
    required this.backgroundColorValue,
    required this.members,
    required this.ownerUid,
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    backgroundColorValue,
    members,
    ownerUid,
  ];
}
