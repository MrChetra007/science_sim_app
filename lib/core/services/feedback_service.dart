import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedbackService {
  static const String _serviceId = 'service_cgdixfi';
  static const String _templateId = 'template_vjd8hsd';
  static const String _publicKey = 'HCuTkniKak_1gNze3';

  static Future<FeedbackResult> sendFeedback({
    required String type,
    required String message,
    required String email,
  }) async {
    try {
      final now = DateTime.now();
      final formattedTime =
          '${now.year}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')} '
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}';

      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost', // ✅ required by EmailJS
        },
        body: json.encode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'name': 'App User',
            'time': formattedTime,
            'message': message,
            'feedback_type': type,
            'user_email': email.isEmpty ? 'Not provided' : email,
          },
        }),
      );

      if (response.statusCode == 200) {
        return FeedbackResult(success: true);
      } else {
        throw Exception('${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      final errorString = e.toString();
      final String friendlyError;

      if (errorString.contains('400') ||
          errorString.contains('parameters are invalid')) {
        friendlyError =
            'Email template configuration error. Please check your EmailJS template settings.';
      } else if (errorString.contains('SocketException') ||
          errorString.contains('Network is unreachable') ||
          errorString.contains('timed out') ||
          errorString.contains('timeout') ||
          errorString.contains('connection')) {
        friendlyError =
            'No internet connection. Please check your connection and try again.';
      } else if (errorString.contains('401') || errorString.contains('403')) {
        friendlyError =
            'Email service configuration error. Please check your EmailJS credentials.';
      } else if (errorString.contains('TimeoutException')) {
        friendlyError = 'Request timed out. Please try again.';
      } else {
        friendlyError =
            'Please try again later. If the problem persists, contact support.';
      }

      return FeedbackResult(success: false, error: friendlyError);
    }
  }
}

class FeedbackResult {
  final bool success;
  final String? error;

  const FeedbackResult({required this.success, this.error});
}
