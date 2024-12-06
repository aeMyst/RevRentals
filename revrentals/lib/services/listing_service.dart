import 'dart:convert';
import 'package:http/http.dart' as http;

class ListingService {
  final String _baseUrl =
      "http://10.0.2.2:8000/api"; // Update with your backend URL

  /// Adds a motorized vehicle listing to the garage.
  // Future<Map<String, dynamic>> addListing(
  //     Map<String, dynamic> listingData) async {
  //   final url = Uri.parse("$_baseUrl/add-listing/");
  //   final response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode(listingData),
  //   );

  //   if (response.statusCode == 201) {
  //     return {"success": true, "message": "Listing added successfully"};
  //   } else {
  //     final error = jsonDecode(response.body);
  //     throw Exception(error["error"] ?? "Failed to add listing");
  //   }
  // }

  Future<Map<String, dynamic>> addListing(
      Map<String, dynamic> listingData) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/add-listing/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(listingData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {"error": jsonDecode(response.body)['error']};
    }
  }

  /// Adds a motorized vehicle listing to the garage.
  // Future<Map<String, dynamic>> addGearListing(
  //     Map<String, dynamic> listingData) async {
  //   final url = Uri.parse("$_baseUrl/add-gear-listing/");
  //   final response = await http.post(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //     body: jsonEncode(listingData),
  //   );

  //   if (response.statusCode == 201) {
  //     return {"success": true, "message": "Gear listing added successfully"};
  //   } else {
  //     final error = jsonDecode(response.body);
  //     throw Exception(error["error"] ?? "Failed to add gear listing");
  //   }
  // }
  Future<Map<String, dynamic>> addGearListing(
      Map<String, dynamic> listingData) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/add-gear-listing/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(listingData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {"error": jsonDecode(response.body)['error']};
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
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(listingData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        // The success response will include the reservation number
        return {
          "success": true,
          "message": "Reservation added successfully",
          "reservation_no": data['reservation_no']
        };
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      throw Exception("Failed to add reservation: $e");
    }
  }

  // Fetch all maint records for a vehicle.
  Future<List<dynamic>> fetchMaintRecords({required String vin}) async {
    final url = Uri.parse("$_baseUrl/motorized-vehicles/$vin/");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['maintenance_records'] as List<dynamic>;
      } else {
        throw Exception(
            "Failed to fetch maintenance records: ${response.body}");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }

  // Adds maintenance records for a vin
  Future<Map<String, dynamic>> addMaintRecords(
      List<Map<String, dynamic>> recordsData) async {
    final url = Uri.parse("$_baseUrl/add-maintenance-records/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(recordsData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body); // Backend response
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error["error"] ?? "Failed to add maintenance records");
    }
  }

  // Creates a new agreement for a reservation and returns agreement details
  Future<Map<String, dynamic>> addAgreement(
      Map<String, dynamic> agreementData) async {
    final url = Uri.parse("$_baseUrl/add-agreement/");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(agreementData),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Return the complete agreement details for the transaction page
        return {
          "success": true,
          "message": data['message'],
          "item_name": data['item_name'],
          "item_type": data['item_type'],
          "rental_overview": data['rental_overview'],
          "agreement_fee": data['agreement_fee'],
          "damage_compensation": data['damage_compensation']
        };
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      throw Exception("Failed to create agreement: $e");
    }
  }

  // Creates a new transaction for a reservation and returns transaction details
  Future<Map<String, dynamic>> addTransaction(
      Map<String, dynamic> transactionData) async {
    final url = Uri.parse("$_baseUrl/add-transaction/");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(transactionData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      throw Exception("Failed to process transaction: $e");
    }
  }

  Future<Map<String, dynamic>> fetchAgreement(int reservationNo) async {
    final url = Uri.parse("$_baseUrl/view-agreement/$reservationNo/");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  Future<Map<String, dynamic>> fetchTransaction(int reservationNo) async {
    final url = Uri.parse("$_baseUrl/view-transaction/$reservationNo/");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['error']);
    }
  }

  /// Fetches complete reservation details including renter information
  Future<Map<String, dynamic>> fetchReservationDetails(
      int reservationNo) async {
    final url = Uri.parse("$_baseUrl/view-reservation-details/$reservationNo/");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(jsonDecode(response.body)['error']);
      }
    } catch (e) {
      throw Exception("Failed to fetch reservation details: $e");
    }
  }

  // Fetch notifications for the seller
  Future<List<dynamic>> fetchSellerNotifications(int profileId) async {
    final url = Uri.parse("$_baseUrl/notifications/seller/$profileId/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true &&
            jsonResponse['notifications'] is List) {
          return jsonResponse['notifications'] as List<dynamic>;
        } else {
          return []; // Return an empty list if notifications are not found
        }
      } else {
        throw Exception(
            "Failed to fetch notifications. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchSellerNotifications: $e");
      return [];
    }
  }

  Future<List<dynamic>> fetchBuyerNotifications(int buyerId) async {
    final response =
        await http.get(Uri.parse("$_baseUrl/notifications/buyer/$buyerId/"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['notifications'];
    } else {
      throw Exception("Failed to fetch buyer notifications");
    }
  }

  // Approve or reject a reservation
  Future<void> updateReservationStatus(int reservationNo, String action) async {
    final url = Uri.parse("$_baseUrl/reservations/$reservationNo/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"action": action}),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error["error"] ?? "Failed to update reservation");
    }
  }

  Future<void> deleteReservation(int reservationNo) async {
    final response = await http
        .delete(Uri.parse("$_baseUrl/notifications/delete/$reservationNo/"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete reservation");
    }
  }

  // showing rented items to user
  Future<List<dynamic>> fetchBuyerRentalHistory(int profileId) async {
    final url = Uri.parse("$_baseUrl/rentals/buyer/$profileId/");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true &&
            jsonResponse['rental_history'] is List) {
          return jsonResponse['rental_history'] as List<dynamic>;
        } else {
          return [];
        }
      } else {
        throw Exception(
            "Failed to fetch rental history. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in fetchBuyerRentalHistory: $e");
      return [];
    }
  }

  Future<bool> updateRentalPrice({
    required String itemType,
    required dynamic itemId,
    required double newPrice,
  }) async {
    final url = Uri.parse("$_baseUrl/update-rental-price/");
    final body = {
      "item_type": itemType,
      "id": itemId,
      "new_price": newPrice,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        print("Rental price updated successfully!");
        return true;
      } else {
        print("Failed to update rental price: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error during API call: $e");
      return false;
    }
  }

  Future<bool> checkNotifications(int profileId) async {
    final url = Uri.parse("$_baseUrl/notifications/check/$profileId/");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true &&
            jsonResponse['has_notifications'] is bool) {
          return jsonResponse['has_notifications'];
        }
      }
      return false; // Default to no notifications
    } catch (e) {
      print("Error in checkNotifications: $e");
      return false;
    }
  }
}
