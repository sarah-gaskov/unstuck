import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  //main server URL on Fly.io
  final String baseUrl = 'https://unstuck.fly.dev/api';

  //Check if server is running
  Future<bool> checkServer() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // == Login ==

  Future<bool> registerUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),

        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Login error: $e');
      return false; // Return false if the request fails
    }
  }

  // == Query and Answer ==

  // - Read from the DB -

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

  // Notifications
  Future<List> getNotifications() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/notifications'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Connection error: $e');
      return [];
    }
  }
  //- New entry to DB -

  //POST - Add an inquiry to the database
  Future<bool> addInquiry(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create-entry'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'resource': 'inquiries',
          'data': {
            'body': body,
            'title': title,
            'chosen_answer_id': null,
            'is_solved': false,
          },
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  //POST - Add an answer to the db
  Future<bool> addAnswer(int inquiryId, String answerText) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create-entry'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'resource': 'answers',
          'data': {'inquiry_id': inquiryId, 'body': answerText},
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending answer: $e');
      return false;
    }
  }

  // get only the questions that THIS user asked
  // we pass userId so the server filters by asker_id in the inquiries table
  // reference: GET /api/my-questions/:userId in server.js
  Future<List> getMyQuestions(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/my-questions/$userId'),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error fetching my questions: $e');
      return [];
    }
  }

  // get all answers THIS mechanic has submitted
  // the server joins answers with inquiries so we also get the question title back
  // reference: GET /api/my-answers/:userId in server.js
  Future<List> getMyAnswers(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/my-answers/$userId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Error fetching my answers: $e');
      return [];
    }
  }
}
