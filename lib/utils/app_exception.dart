abstract class AppException implements Exception {
  final String message;

  const AppException(this.message);
}

class UserNotFoundException extends AppException {
  const UserNotFoundException() : super('User not found');
}

class LoginException extends AppException {
  const LoginException()
    : super('Something wrong happened, could not sign you in right now');
}

class RegisterException extends AppException {
  const RegisterException()
    : super('Something wrong happened, could not sign you up right now');
}

class LogoutException extends AppException {
  const LogoutException()
    : super('Something wrong happened, could not sign you out right now');
}

class DiskIOException extends AppException {
  const DiskIOException()
    : super('Could not read/ write data to internal storage');
}

class FirestoreException extends AppException {
  const FirestoreException()
    : super('Could not read/ write data to remote database');
}
