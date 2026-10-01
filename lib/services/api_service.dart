import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiService {
  // Flutter Windows + FastAPI running on the same PC
  static const String baseUrl = 'http://127.0.0.1:8000';

  // --------------------------------------------------
  // LOGIN
  // --------------------------------------------------

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      final body = _decodeResponse(response);

      if (response.statusCode == 200) {
        return body;
      }

      throw Exception(
        body['detail'] ?? 'Login failed. Please try again.',
      );
    } on SocketException {
      throw Exception(
        'Cannot connect to AksharaaSetu backend.',
      );
    } on http.ClientException {
      throw Exception(
        'Network connection failed.',
      );
    }
  }

  // --------------------------------------------------
  // REGISTER
  // --------------------------------------------------

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final uri = Uri.parse('$baseUrl/api/auth/register');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      final body = _decodeResponse(response);

      if (response.statusCode == 200) {
        return body;
      }

      throw Exception(
        body['detail'] ??
            'Registration failed. Please try again.',
      );
    } on SocketException {
      throw Exception(
        'Cannot connect to AksharaaSetu backend.',
      );
    } on http.ClientException {
      throw Exception(
        'Network connection failed.',
      );
    }
  }

  // --------------------------------------------------
  // FORGOT PASSWORD
  // --------------------------------------------------

  static Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/auth/forgot-password',
    );

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      );

      final body = _decodeResponse(response);

      if (response.statusCode == 200) {
        return body;
      }

      throw Exception(
        body['detail'] ??
            'Password reset request failed.',
      );
    } on SocketException {
      throw Exception(
        'Cannot connect to AksharaaSetu backend.',
      );
    }
  }

  // --------------------------------------------------
  // RESET PASSWORD
  // --------------------------------------------------

  static Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/auth/reset-password',
    );

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': token,
          'new_password': newPassword,
        }),
      );

      final body = _decodeResponse(response);

      if (response.statusCode == 200) {
        return body;
      }

      throw Exception(
        body['detail'] ??
            'Password reset failed.',
      );
    } on SocketException {
      throw Exception(
        'Cannot connect to AksharaaSetu backend.',
      );
    }
  }

  // --------------------------------------------------
  // TEXT TRANSLATION
  // --------------------------------------------------

  static Future<Map<String, dynamic>> translate({
    required String sourceLanguage,
    required String targetLanguage,
    required String mode,
    required String text,
    String? lessonId,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/translation',
    );

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'source_language': sourceLanguage,
          'target_language': targetLanguage,
          'mode': mode,
          'text': text,
          'lesson_id': lessonId,
        }),
      );

      final body = _decodeResponse(response);

      if (response.statusCode == 200) {
        return body;
      }

      throw Exception(
        body['detail'] ??
            'Translation failed.',
      );
    } on SocketException {
      throw Exception(
        'Cannot connect to AksharaaSetu backend.',
      );
    }
  }

  // --------------------------------------------------
  // SPEECH → TEXT → TRANSLATION
  // --------------------------------------------------

  static Future<Map<String, dynamic>> speechToSpeech({
    required File audioFile,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final uri = Uri.parse(
      '$baseUrl/api/speech-to-speech',
    );

    try {
      final request = http.MultipartRequest(
        'POST',
        uri,
      );

      request.fields['source_language'] =
          sourceLanguage;

      request.fields['target_language'] =
          targetLanguage;

      request.files.add(
        await http.MultipartFile.fromPath(
          'audio',
          audioFile.path,
        ),
      );

      final streamedResponse =
          await request.send();

      final response =
          await http.Response.fromStream(
        streamedResponse,
      );

      final body = _decodeResponse(response);

      if (response.statusCode == 200) {
        return body;
      }

      throw Exception(
        body['detail'] ??
            'Speech translation failed.',
      );
    } on SocketException {
      throw Exception(
        'Cannot connect to AksharaaSetu backend.',
      );
    }
  }

  // --------------------------------------------------
  // RESPONSE HELPER
  // --------------------------------------------------

  static Map<String, dynamic> _decodeResponse(
    http.Response response,
  ) {
    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {
        'detail': response.body,
      };
    } catch (_) {
      return {
        'detail': response.body.isEmpty
            ? 'Empty response from server.'
            : response.body,
      };
    }
  }
}