import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminService {
  final String _baseUrl = "http://10.0.2.2:8000/api";

  Future<Map<String, dynamic>> adminLogin(
      String username, String password) async {
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

  Future<List<dynamic>> fetchReservations() async {
    final url = Uri.parse("$_baseUrl/reservations/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reservations'] as List<dynamic>;
      } else {
        throw Exception("Failed to fetch reservations: ${response.body}");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  Future<Map<String, dynamic>> addLotListing(Map<String, dynamic> lotData) async {

    final url = Uri.parse("$_baseUrl/add-lot-listing/");
    
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(lotData),
    );

    if (response.statusCode == 201) {
      return {"success": true, "message": "Listing added successfully"};
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["error"] ?? "Failed to add listing");
    }
  }
}
