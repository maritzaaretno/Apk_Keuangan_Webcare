import 'package:Webcare/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class MonthlyReportController {
  final FlutterSecureStorage secureStorage;

  MonthlyReportController(this.secureStorage);

  Future<String?> _getToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  Future<List<Map<String, dynamic>>?> getMonthlyReport(String userId) async {
    final dio = Dio();
    final url = '$baseUrl/monthly-report/monthly-report';

    try {
      final token = await _getToken();
      if (token == null) {
        print('Error: No token found');
        return null;
      }

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response monthly rprt data: \n\n\n ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data['data'];
        print('Response Data: $responseData');
        Logger().i(responseData);
        // Convert the list of dynamic objects to a list of maps
        return responseData.cast<Map<String, dynamic>>();
      } else {
        print('Failed to fetch monthly report data');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
