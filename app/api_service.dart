import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  //main server URL on Fly.io
  final String baseUrl = 'https://unstuck.fly.dev/api';

  //Check if server is running
  Future<bool> checkServer() async {
    try {
      final response = await http.get(Uri.parse('https://unstuck.fly.dev/'));
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
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<String?> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['user']['username'];
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
  
  Future<String?> loginGuest(String username, String password) async {
		try {			
			final response = await http.get(Uri.parse('$baseUrl/login-guest'));
			if (response.statusCode == 200) {
				final data = jsonDecode(response.body);
				return data['username'];
			}
			
			return null
		} catch (e) {
			print('Login error: $e');
			return null
		}
	}
	
	Future<void> deleteGuest(String username) async {
		try {
			await http.delete(
				Uri.parse('$baseUrl/delete-guest'),
				headers: {'Content-Type' : 'application/json'},
				body: jsonEncode({'username': username}),
			);
		} catch (e) {
			print('Error deleting guest: $e');
		}
	}

  // == Get Inquiry Data ==

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
  
  //Get question + all answers to question
  Future<List> getQAndA() async {
	try {
      final response = await http.get(Uri.parse('$baseUrl/qna'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Connection error: $e');
      return [];
    }
  }
  
  // = Edit Inquiry Data =

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
          'data': {
            'inquiry_id': inquiryId,
            'body': answerText,
          },
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error sending answer: $e');
      return false;
    }
  }
}