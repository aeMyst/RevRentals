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

  // Method to fetch profile ID using username
  Future<int> fetchAdminID() async {
    final url = Uri.parse("$_baseUrl/get-admin-id/");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["admin_id"];
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["error"] ?? "Failed to fetch Admin ID");
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
      throw Exception("An error occurred trying to fetch reservations: $e");
    }
  }

  Future<Map<String, dynamic>> fetchReservationDetails(int reservationNo) async {
    final url = Uri.parse("$_baseUrl/view-reservation-details/$reservationNo/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception("Failed to fetch reservation details: ${response.body}");
      }
    } catch (e) {
      throw Exception("An error occurred trying to fetch reservation details: $e");
    }
  }
  Future<Map<String, dynamic>> fetchTransaction(int reservationNo) async {
    final url = Uri.parse("$_baseUrl/get-transaction/$reservationNo/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['transaction'];
      } else {
        throw Exception("Failed to fetch transaction: ${response.body}");
      }
    } catch (e) {
      throw Exception("An error occurred trying to fetch transaction: $e");
    }
  }

  Future<Map<String, dynamic>> fetchAgreement(int reservationNo) async {
    final url = Uri.parse("$_baseUrl/get-agreement/$reservationNo/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['agreement'];
      } else {
        throw Exception("Failed to fetch agreement: ${response.body}");
      }
    } catch (e) {
      throw Exception("An error occurred trying to fetch agreement: $e");
    }
  }

  // Future<Map<String, dynamic>> fetchAgreement(int reservationNo) async {
  //   final url = Uri.parse("$_baseUrl/view-agreement/$reservationNo/");
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return data['agreement'];
  //     } else {
  //       throw Exception("Failed to fetch agreement: ${response.body}");
  //     }
  //   } catch (e) {
  //     throw Exception("An error occurred trying to fetch agreement: $e");
  //   }
  // }

  Future<Map<String, dynamic>> addLotListing(
      Map<String, dynamic> lotData) async {
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

  Future<Map<String, dynamic>> updateLotListing(
      Map<String, dynamic> updatedLotData) async {
    final url = Uri.parse("$_baseUrl/edit-lot-listing/");
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(updatedLotData),
    );

    if (response.statusCode == 200) {
      return {"success": true, "message": "Listing updated successfully"};
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["error"] ?? "Failed to update listing");
    }
  }
}
