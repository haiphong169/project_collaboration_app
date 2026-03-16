sealed class UiState<T> {
  const UiState();

  const factory UiState.loading() = Loading._;
  const factory UiState.success(T data) = Success._;
  const factory UiState.error(String message) = Error._;
}

final class Loading<T> extends UiState<T> {
  const Loading._();
}

final class Success<T> extends UiState<T> {
  const Success._(this.data);

  final T data;
}

final class Error<T> extends UiState<T> {
  const Error._(this.message);

  final String message;
}
