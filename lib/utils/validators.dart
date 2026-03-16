abstract final class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? validateGenericStringField(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }

    if (value.trim().length < 6) {
      return '$label must be at least 6 characters, not counting whitespaces';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match.';
    }

    return null;
  }
}
