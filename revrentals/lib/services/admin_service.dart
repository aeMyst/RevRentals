import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminService {
  final String _baseUrl = "http://10.0.2.2:8000/api";

  Future<Map<String, dynamic>> adminLogin(String username, String password) async {
    final url = Uri.parse("$_baseUrl/admin-login/");
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
}
