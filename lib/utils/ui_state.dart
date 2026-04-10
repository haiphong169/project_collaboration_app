import 'package:equatable/equatable.dart';

typedef VoidUiState = UiState<void>;

sealed class UiState<T> {
  const UiState();

  const factory UiState.loading([T data]) = Loading._;
  const factory UiState.success(T data) = Success._;
  const factory UiState.error(String message, [T data]) = Error._;
  const factory UiState.idle() = Idle._;
  const factory UiState.onNavigationPop() = OnNavigationPop._;
}

final class Loading<T> extends UiState<T> with EquatableMixin {
  const Loading._([this.data]);

  final T? data;

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
  const Error._(this.message, [this.data]);

  final String message;
  final T? data;

  @override
  List<Object?> get props => [message];
}

final class Idle<T> extends UiState<T> with EquatableMixin {
  const Idle._();

  @override
  List<Object?> get props => [];
}

final class OnNavigationPop<T> extends UiState<T> with EquatableMixin {
  const OnNavigationPop._();

  @override
  List<Object?> get props => [];
}
