import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  //main server URL on Fly.io
  final String baseUrl = 'https://unstuck.fly.dev';

  //Check if server is running
  Future<bool> checkServer() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  //Get all inquiries from database
  Future<List> getInquiries() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/inquiries'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Connection error: $e');
      return [];
    }
  }

  //Get all answers from database
  Future<List> getAnswers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/answers'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Connection error: $e');
      return [];
    }
  }

  //POST - Send an inquiry to the database
  Future<bool> sentInquiry(String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/inquiries'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}