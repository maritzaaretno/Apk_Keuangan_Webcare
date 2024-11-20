import 'package:Webcare/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class DailyReportController {
  final String userId;
  final FlutterSecureStorage secureStorage;
  final Dio dio;

  DailyReportController(this.userId, this.secureStorage, this.dio);

  Future<String?> _getToken() async {
    return await secureStorage.read(key: 'access_token');
  }

  Future<Map<String, dynamic>?> getDailyTransactions(DateTime date) async {
    final url = '$baseUrl/daily-report/transaction-by-day';
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    try {
      final token = await _getToken();
      if (token == null) {
        print('Error: No token found');
        return null;
      }

      final response = await dio.get(
        url,
        queryParameters: {
          'user_id': userId,
          'date_time': formattedDate,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('API Response: ${response.data}'); // Log lengkap respons API

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data as Map<String, dynamic>;

        final List<dynamic> incomes = responseData['incomes'] ?? [];
        final List<dynamic> expenses = responseData['expenses'] ?? []; // Perbaikan di sini

        List<Map<String, dynamic>> incomeList = incomes.map((income) {
          print('Income ID: ${income['id']}');
          return {
            'id': income['id'],
            'title': income['name'],
            'date': income['date_time'],
            'amount': double.tryParse(income['amount'].toString()) ?? 0.0,
            'color': Colors.green,
          };
        }).toList();

        List<Map<String, dynamic>> expenseList = expenses.map((expense) {
          print('Expense ID: ${expense['id']}');
          return {
            'id': expense['id'], // Perbaikan di sini
            'title': expense['name'],
            'date': expense['date_time'],
            'amount': double.tryParse(expense['amount'].toString()) ?? 0.0,
            'color': Colors.red,
          };
        }).toList();

        Map<String, dynamic> dailyTransactions = {
          'income': incomeList,
          'expense': expenseList,
        };

        print('Parsed Daily Transactions: $dailyTransactions');
        return dailyTransactions;
      } else {
        print('Failed to fetch data');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }






  Future<Map<String, double>?> getTotalIncomesAndExpenses() async {
    final url = '$baseUrl/daily-report/totals-incomes-expanse';

    try {
      final token = await _getToken();
      if (token == null) {
        print('Error: No token found');
        return null;
      }

      final response = await dio.get(
        url,
        queryParameters: {
          'user_id': userId,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data as Map<String, dynamic>;
        print('Response Data: $responseData');  // Log the response data

        double totalIncome = double.tryParse(responseData['data']['total_income'].toString()) ?? 0.0;
        double totalExpense = double.tryParse(responseData['data']['total_expanse'].toString()) ?? 0.0;

        return {
          'income': totalIncome,
          'expense': totalExpense,
        };
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> deleteTransaction(int transactionId, bool isIncome) async {
    try {
      final token = await _getToken(); // Metode untuk mendapatkan token akses

      if (token == null) {
        print('Token akses tidak ditemukan.');
        return false;
      }

      final endpoint = isIncome ? '/incomes/$transactionId' : '/expanse/$transactionId';
      final response = await dio.delete(
        '$baseUrl$endpoint',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Gagal menghapus transaksi. Status kode: ${response.statusCode}');
        return false;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        print('Transaksi tidak ditemukan.');
        return false;
      } else {
        print('Error Dio: $e');
        return false;
      }
    } catch (e) {
      print('Error menghapus transaksi: $e');
      return false;
    }
  }




}
