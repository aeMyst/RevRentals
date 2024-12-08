class Validators {
  // Validate required fields
  static String? validateRequiredField(String fieldName, String value) {
    if (value.isEmpty) {
      return "$fieldName is required.";
    }
    return null;
  }

  // Validate email using simple regex
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return "Email is required.";
    }
    // https://stackoverflow.com/questions/50330109/simple-regex-pattern-for-email
    // Start at beginning of string or line
    //  Include all characters except @ until the @ sign
    //  Include the @ sign
    //  Include all characters except @ after the @ sign until the full stop
    //  Include all characters except @ after the full stop
    //  Stop at the end of the string or lin
    if (!RegExp(r"^[^@]+@[^@]+\.[^@]+$").hasMatch(value)) {
      return "Invalid email format.";
    }
    return null;
  }

  // Validate username using specific regex
  static String? validateUsername(String value) {
    if (value.isEmpty) {
      return "Username is required.";
    }
    // https://dev.to/fromwentzitcame/username-and-password-validation-using-regex-2175
    // can only contain letters and numbers, and must be between 6-16 characeters
    if (!RegExp(r"^[0-9A-Za-z]{6,16}$").hasMatch(value)) {
      return "Username must be 6-16 characters long and only contain letters and numbers.";
    }
    return null;
  }

  // Validate password (minimum 5 characters)
  static String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Password is required.";
    }
    // https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    // Minimum 5 characters
    // at least one letter and one number
    if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,}$").hasMatch(value)) {
      return "Password must be at least 5 characters long and contain atleast 1 letter and 1 number";
    }
    return null;
  }

  // Validate confirm password
  static String? validateConfirmPassword(
      String value, String originalPassword) {
    if (value.isEmpty) {
      return "Confirm Password is required.";
    }
    if (value != originalPassword) {
      return "Passwords do not match.";
    }
    return null;
  }
}
