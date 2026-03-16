import 'package:logger/logger.dart';

class AppLogger extends Logger {
  static final AppLogger _instance = AppLogger._internal();

  factory AppLogger() => _instance;

  AppLogger._internal()
    : super(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
          lineLength: 50,
          colors: true,
          printEmojis: true,
        ),
      );
}
