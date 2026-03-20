sealed class SearchUserEvent {}

class SearchQueryChanged extends SearchUserEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class SearchCleared extends SearchUserEvent {}
