import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl =
      "http://10.0.2.2:8000/api"; 

  // Login method
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("$_baseUrl/login/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  // Register method
  // Register method in AuthService
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    final url = Uri.parse("$_baseUrl/register/");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      print("Response status: ${response.statusCode}"); // Debug print
      print("Response body: ${response.body}"); // Debug print

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        return {
          "success": false,
          "error": errorData["error"] ?? "Registration failed"
        };
      }
    } catch (e) {
      print("Registration service error: $e"); // Debug print
      return {
        "success": false,
        "error": e.toString()
      };
    }
  }

  // Method to fetch profile ID using username
  Future<int> fetchProfileId(String username) async {
    final url = Uri.parse("$_baseUrl/get-profile-id/$username/");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["profile_id"];
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["error"] ?? "Failed to fetch profile ID");
    }
  }

  Future<Map<String, dynamic>> fetchProfileDetails(int profileId) async {
    final url = Uri.parse("$_baseUrl/profile-details/$profileId/");
    
    try {
        final response = await http.get(
            url,
            headers: {"Content-Type": "application/json"},
        );

        print("Response status: ${response.statusCode}"); // Debug print
        print("Response body: ${response.body}"); // Debug print

        if (response.statusCode == 200) {
            return jsonDecode(response.body);
        } else {
            throw Exception(jsonDecode(response.body)['error'] ?? "Failed to fetch profile details");
        }
    } catch (e) {
        print("Profile details fetch error: $e"); // Debug print
        throw Exception("Failed to fetch profile details: $e");
    }
  }


  // Profile Details method
  Future<Map<String, dynamic>> saveProfileDetails(
      int profileId, Map<String, dynamic> profileData) async {
    final url = Uri.parse("$_baseUrl/profile-details/");
    
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"profile_id": profileId, ...profileData}),
    );

    print("Response status: ${response.statusCode}"); // Debug print
    print("Response body: ${response.body}"); // Debug print

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error'] ?? "Failed to save profile details");
    }
  }
}