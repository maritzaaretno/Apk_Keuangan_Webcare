import 'package:Webcare/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AddTransactionController {
  final String userId;
  final FlutterSecureStorage secureStorage;

  AddTransactionController(this.userId, this.secureStorage);

  Future<String?> _getToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  Future<bool> addTransaction(bool isIncome, String title, String amount, String description, DateTime date) async {
    final dio = Dio();
    final url = isIncome
        ? '$baseUrl/incomes'
        : '$baseUrl/expanse';

    print('Attempting to post to: $url');
    print('Data: {user_id: $userId, name: $title, amount: $amount, date_time: ${date.toIso8601String()}, description: $description}');

    try {
      final token = await _getToken();
      if (token == null) {
        print('Error: No token found');
        return false;
      }

      final response = await dio.post(
        url,
        data: {
          'user_id': userId,
          'name': title,
          'amount': double.parse(amount),
          'date_time': date.toIso8601String().substring(0, 10),
          'description': description,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (e is DioError) {
        print('Dio error: ${e.message}');
        if (e.response != null) {
          print('Dio response status: ${e.response?.statusCode}');
          print('Dio response data: ${e.response?.data}');
        } else {
          print('Dio error without response: ${e.message}');
        }
      } else {
        print('Unexpected error: $e');
      }
      return false;
    }
  }
}
