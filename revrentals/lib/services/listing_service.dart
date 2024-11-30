import 'dart:convert';
import 'package:http/http.dart' as http;

class ListingService {
  final String _baseUrl =
      "http://10.0.2.2:8000/api"; // Update with your backend URL

  /// Adds a motorized vehicle listing to the garage.
  Future<Map<String, dynamic>> addListing(
      Map<String, dynamic> listingData) async {
    final url = Uri.parse("$_baseUrl/add-listing/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(listingData),
    );

    if (response.statusCode == 201) {
      return {"success": true, "message": "Listing added successfully"};
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["error"] ?? "Failed to add listing");
    }
  }
  /// Adds a motorized vehicle listing to the garage.
  Future<Map<String, dynamic>> addGearListing(
      Map<String, dynamic> listingData) async {
    final url = Uri.parse("$_baseUrl/add-gear-listing/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(listingData),
    );

    if (response.statusCode == 201) {
      return {"success": true, "message": "Gear listing added successfully"};
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["error"] ?? "Failed to add gear listing");
    }
  }
  /// Fetches the garage ID for a specific profile ID.
  Future<int> fetchGarageId(int profileId) async {
    final url = Uri.parse("$_baseUrl/get-garage-id/$profileId/");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["garage_id"];
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["error"] ?? "Failed to fetch garage ID");
    }
  }

  /// Fetches all listings (motorized vehicles and gear) for a specific garage.
  Future<Map<String, dynamic>> viewGarageItems(int garageId) async {
    final url = Uri.parse("$_baseUrl/view-listing/?garage_id=$garageId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["error"] ?? "Failed to fetch listings");
    }
  }

  // Fetch all motorized vehicles
  Future<List<dynamic>> fetchMotorizedVehicles() async {
    final url = Uri.parse("$_baseUrl/motorized-vehicles/");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['motorized_vehicles'] as List<dynamic>;
      } else {
        throw Exception("Failed to fetch motorized vehicles: ${response.body}");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  /// Fetch all storage lots.
  Future<List<dynamic>> fetchStorageLots() async {
    final url = Uri.parse("$_baseUrl/storage-lots/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['storage_lots'] as List<dynamic>;
      } else {
        throw Exception("Failed to fetch storage lots: ${response.body}");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  /// Fetch all gear items.
  Future<List<dynamic>> fetchGearItems() async {
    final url = Uri.parse("$_baseUrl/gear-items/");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['gear_items'] as List<dynamic>;
      } else {
        throw Exception("Failed to fetch gear items: ${response.body}");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }


  /// Adds a motorized vehicle listing to the garage.
  Future<Map<String, dynamic>> addReservation(
      Map<String, dynamic> listingData) async {
    final url = Uri.parse("$_baseUrl/add-reservation/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(listingData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body); // Backend response

    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["error"] ?? "Failed to add reservation");
    }
  }


}
