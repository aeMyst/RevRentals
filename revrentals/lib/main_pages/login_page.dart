import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revrentals/admin/admin_login.dart';
import 'package:revrentals/components/my_button.dart';
import 'package:revrentals/components/my_textfield.dart';
import 'package:revrentals/user/profile_detail.dart';
import 'package:revrentals/user/user_home.dart';
import 'package:revrentals/regex/signup_regex.dart';
import '../services/auth_service.dart'; // Import AuthService

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailOrUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController(); // For Login
  final signUpPasswordController = TextEditingController(); // For Sign-Up
  final confirmPasswordController = TextEditingController(); // For Sign-Up
  final usernameController = TextEditingController(); // For Sign-Up
  final AuthService _authService = AuthService();

  bool isSignUpMode = false;
  bool isLoading = false;

  void toggleAuthMode(bool isSignUp) {
    setState(() {
      isSignUpMode = isSignUp;
      loginPasswordController.clear(); // Clear login-specific password field
      signUpPasswordController.clear(); // Clear sign-up-specific password field
      confirmPasswordController.clear(); // Clear confirm password field
    });
  }

  Future<void> authenticateUser(BuildContext context) async {
    if (isSignUpMode) {
      await signUpUser(context);
    } else {
      await signInUser(context);
    }
  }

  Future<void> signInUser(BuildContext context) async {
    String input = emailOrUsernameController.text.trim();
    String password = loginPasswordController.text;

    if (input.isEmpty || password.isEmpty) {
      showError(context, "Email/Username and Password are required Fields.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await _authService.login(input, password);

      if (response['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserHomePage(userData: response['user']),
          ),
        );
      } else {
        showError(context, response['error']);
      }
    } catch (e) {
      showError(context,
          "Your Username/Email or Password Were Incorrect, Try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signUpUser(BuildContext context) async {
    String username = usernameController.text.trim();
    String emailOrUsername = emailOrUsernameController.text.trim();
    String password = signUpPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Validate input with regex before making backend call
    String? usernameError = Validators.validateUsername(username);
    String? emailError = Validators.validateEmail(emailOrUsername);
    String? passwordError = Validators.validatePassword(password);
    String? confirmPasswordError =
        Validators.validateConfirmPassword(confirmPassword, password);

    if ([usernameError, emailError, passwordError, confirmPasswordError]
        .any((error) => error != null)) {
      showError(
          context,
          usernameError ??
              emailError ??
              passwordError ??
              confirmPasswordError!);
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await _authService.register({
        "username": username,
        "email": emailOrUsername,
        "password": password,
      });

      if (response['success']) {
        final profileId = response['data']['profile_id'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileDetailsPage(profileId: profileId)),
        );
      } else {
        showError(context, response['error'] ?? "Registration failed");
      }
    } catch (e) {
      showError(context, "An error occurred. Please try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Error",
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void getAdminPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminLoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0), // Add padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/images/rr_logo.png',
                      height: 300,
                    ),
                  ],
                ),
                const Text(
                  'Welcome to RevRentals',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Create an account or log in to access the app.',
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 25),
                CupertinoSlidingSegmentedControl<int>(
                  children: const {
                    0: Text('Log In', style: TextStyle(fontSize: 16)),
                    1: Text('Sign Up', style: TextStyle(fontSize: 16)),
                  },
                  groupValue: isSignUpMode ? 1 : 0,
                  onValueChanged: (int? newValue) {
                    toggleAuthMode(newValue == 1);
                  },
                ),
                const SizedBox(height: 20),
                if (isSignUpMode) ...[
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Username must be 6-16 characters long and only contain letters and numbers.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                ],
                MyTextField(
                  controller: emailOrUsernameController,
                  hintText: isSignUpMode ? 'Email' : 'Email or Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                if (isSignUpMode) ...[
                  MyTextField(
                    controller: signUpPasswordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Password must be at least 5 characters, with one letter and one number.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                ] else ...[
                  MyTextField(
                    controller: loginPasswordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                ],
                const SizedBox(height: 15),
                MyButton(
                  onTap: () => authenticateUser(context),
                  label: isLoading
                      ? 'Loading...'
                      : (isSignUpMode ? 'Sign Up' : 'Log In'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => getAdminPage(context),
                  child: const Text(
                    'Sign in as Admin',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
