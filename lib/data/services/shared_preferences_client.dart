import 'package:project_collaboration_app/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClient {
  final _prefs = SharedPreferencesAsync();

  static const String _AUTH_KEY = 'auth';

  Future<Result<void>> setAuth(bool value) async {
    try {
      await _prefs.setBool(_AUTH_KEY, value);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<bool?>> getAuth() async {
    try {
      return Result.ok(await _prefs.getBool(_AUTH_KEY));
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }
}
