import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../../config.dart'; // Pastikan Anda mengganti import ini sesuai dengan lokasi file config.dart Anda

class DetailReportController {
  final FlutterSecureStorage secureStorage;

  DetailReportController(this.secureStorage);

  Future<String?> _getToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  Future<Map<String, dynamic>?> getDetailReport(int year, int month) async {
    final dio = Dio();
    final url = '$baseUrl/monthly-report/detail-monthly-report';

    try {
      final token = await _getToken();
      if (token == null) {
        print('Error: No token found');
        return null;
      }

      final response = await dio.get(
        url,
        queryParameters: {
          'year': year,
          'month': month,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        Logger().i(data);
        print(data);

        // final parsedData = {
        //   'year': data['year'],
        //   'month': data['month'],
        //   'total_income': double.tryParse(data['total_income'].toString()),
        //   'total_expenses': double.tryParse(data['total_expenses']).toString(),
        //   'remaining_balance':
        //       double.tryParse(data['remaining_balance'].toString()),
        //   'transactions': data['transactions'],
        // };

        // return parsedData;
        data["total_income"] = double.tryParse(data['total_income'].toString());
        data["total_expenses"] =
            double.tryParse(data['total_expenses'].toString());
        data["remaining_balance"] =
            double.tryParse(data['remaining_balance'].toString());
        return data;
      } else {
        print(
            'Failed to fetch detail report data, status code: ${response.statusCode}');
        throw Exception('Failed to fetch detail report data');
      }
    } catch (e) {
      Logger().e(e);
      throw Exception('Failed to fetch detail report data');
    }
  }
}
