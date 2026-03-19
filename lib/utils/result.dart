import 'package:project_collaboration_app/utils/app_exception.dart';

typedef VoidResult = Result<void>;

sealed class Result<T> {
  const Result();

  const factory Result.ok(T data) = Ok._;

  const factory Result.failure(AppException error) = Failure._;
}

final class Ok<T> extends Result<T> {
  const Ok._(this.data);

  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure._(this.error);

  final AppException error;
}
