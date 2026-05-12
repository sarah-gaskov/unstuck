import 'package:flutter_test/flutter_test.dart';
import '../app/api_service.dart';

void main() {
  //Test 1: check the API URL is correct
  test('Apiservice URL is correct', () {
    final api = ApiService();
    expect(api.baseUrl, 'https://unstuck-test.fly.dev/api');
  });

  //Test 2: Loging in with wrong credentials return null
  test('login returns null with wrong credentials',() async {
    final api = ApiService();
    final result = await api.loginUser('wronguser','wrongpassword');
    expect(result, null);
  });

  //Test 3: Loging in with empty fields return null
  test('loginUser returns null with empty username and password', () async {
    final api = ApiService();
    final result = await api.loginUser('', '');
    expect(result, null);
  });

  //Test 4: Register with empty fields should return false
  test('registerUser returns false with empty username and password', () async {
    final api = ApiService();
    final result = await api.registerUser('', '');
    expect(result, false);
  });

  //Test 5: getBoard returns a List
  test('getBoard returns a list', () async {
    final api = ApiService();
    final result = await api.getBoard();
    expect(result, isA<List>());
  });

  //Test 6: getInquiries returns a List
  test('getInquiries returns a list', () async {
    final api = ApiService();
    final result = await api.getInquiries();
    expect(result, isA<List>());
  });

  //Test 7: getAnswers returns a List
  test('getAnswers returns a list', () async {
    final api = ApiService();
    final result = await api.getAnswers();
    expect(result, isA<List>());
  });

  //Test 8: addInquiry() with empty fields should return false
  test('addInquiry returns false with empty fields', () async {
    final api = ApiService();
    final result = await api.addInquiry('', '', '');
    expect(result, false);
  });

  //Test 9: loginGuest should return username and userId
  test('loginGuest returns username and userId', () async {
    final api = ApiService();
    final result = await api.loginGuest();
    if (result != null) {
      expect(result.containsKey('username'), true);
      expect(result.containsKey('userId'), true);
      // clean up the guest account created by this test
      await api.deleteGuest(result['username']);
    }
  });

  //Test 10: checkServer should return a bool
  test('checkServer returns a bool', () async {
    final api = ApiService();
    final result = await api.checkServer();
    expect(result, isA<bool>());
  });

  // Test 11: getNotifications returns a List
  test('getNotifications returns a list', () async {
    final api = ApiService();
    final result = await api.getNotifications();
    expect(result, isA<List>());
  });

  // Test 12: getMyQuestions returns a List for any userId (empty list for non-existent user)
  test('getMyQuestions returns a list', () async {
    final api = ApiService();
    final result = await api.getMyQuestions('0');
    expect(result, isA<List>());
  });

  // Test 13: getMyAnswers returns a List for any userId (empty list for non-existent user)
  test('getMyAnswers returns a list', () async {
    final api = ApiService();
    final result = await api.getMyAnswers('0');
    expect(result, isA<List>());
  });

  // Test 14: addAnswer with an invalid inquiry ID returns false (fk violation in the db)
  test('addAnswer returns false with invalid inquiryId', () async {
    final api = ApiService();
    final result = await api.addAnswer(0, 'test answer', '0');
    expect(result, false);
  });

  // Test 15: deleteGuest with a non-existent username completes without error
  test('no error for non-existent username', () async {
    final api = ApiService();
    expect(() async => await api.deleteGuest('nonexistent_guest_xyz'), returnsNormally);
  });

  // Test 16: getBoard items have the expected fields when the board isnt empty
  test('getBoard items contain required fields', () async {
    final api = ApiService();
    final result = await api.getBoard();
    expect(result, isA<List>());
    if (result.isNotEmpty) {
      final item = result.first;
      expect(item.containsKey('inquiry_id'), true);
      expect(item.containsKey('title'), true);
      expect(item.containsKey('body'), true);
      expect(item.containsKey('answers'), true);
    }
  });
}
