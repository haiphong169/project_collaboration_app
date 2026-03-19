import 'package:equatable/equatable.dart';

typedef VoidUiState = UiState<void>;

sealed class UiState<T> {
  const UiState();

  const factory UiState.loading() = Loading._;
  const factory UiState.success(T data) = Success._;
  const factory UiState.error(String message) = Error._;
  const factory UiState.idle() = Idle._;
}

final class Loading<T> extends UiState<T> with EquatableMixin {
  const Loading._();

  @override
  List<Object?> get props => [];
}

final class Success<T> extends UiState<T> with EquatableMixin {
  const Success._(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

final class Error<T> extends UiState<T> with EquatableMixin {
  const Error._(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class Idle<T> extends UiState<T> with EquatableMixin {
  const Idle._();

  @override
  List<Object?> get props => [];
}
