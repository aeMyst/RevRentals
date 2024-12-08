class Validators {
  // Validates a VIN (17-digit alphanumeric, excluding I, O, and Q)
  // must also be all uppercase letters if letters included
  static String? validateVIN(String value) {
    final vinRegex = RegExp(r'^[A-HJ-NPR-Z0-9]{17}$');
    if (value.isEmpty) {
      return 'VIN is required.';
    } else if (!vinRegex.hasMatch(value)) {
      return 'Invalid VIN. It must be a 17-character alphanumeric string. If letters are included, must be UPPERCASE.';
    }
    return null; // Valid input
  }

  /// Validates a Registration Number (abc000 format)
  static String? validateRegistration(String value) {
    final registrationRegex = RegExp(r'^[A-Za-z]{3}[0-9]{3}$');
    if (value.isEmpty) {
      return 'Registration is required.';
    } else if (!registrationRegex.hasMatch(value)) {
      return 'Invalid registration. Format must be AbC000.';
    }
    return null; // Valid input
  }
}
