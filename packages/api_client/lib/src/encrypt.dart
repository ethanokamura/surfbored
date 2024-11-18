import 'dart:convert';
import 'package:api_client/api_client.dart' as http;
import 'package:app_core/app_core.dart';

Future<void> submitPhoneNumber({required String phoneNumber}) async {
  try {
    final response = await http.post(
      Uri.parse('https://your-supabase-url/functions/v1/encrypt-phone-number'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to encrypt phone number');
    }

    final data = jsonDecode(response.body);
    // ignore: avoid_dynamic_calls
    if (data['error'] != null) {
      // ignore: avoid_dynamic_calls
      throw Exception(data['error']);
    }
  } catch (e) {
    throw Exception('Failed to encrypt $e');
  }
}
