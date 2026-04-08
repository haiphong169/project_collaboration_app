import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

sealed class SearchUserState {}

class SearchInitial extends SearchUserState {}

class SearchLoading extends SearchUserState {}

class SearchSuccess extends SearchUserState {
  final List<User> users;
  SearchSuccess(this.users);
}

class SearchEmpty extends SearchUserState {}

class SearchError extends SearchUserState {
  final String message;
  SearchError(this.message);
}

class OnNavigation extends SearchUserState {
  final String route;
  final Object? extra;
  OnNavigation(this.route, [this.extra]);
}
