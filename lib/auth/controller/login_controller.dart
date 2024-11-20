import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../config.dart';
import '../../model/user_model.dart';
import '../../report/report_screen.dart';

class LoginController {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  User? _user;

  String? email;
  String? password;
  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      var data = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      try {
        isLoading = true;
        Dio dio = Dio();
        var response = await dio.post(
          '$baseUrl/login',
          data: data,
        );

        isLoading = false;

        if (response.statusCode == 200) {
          if (response.data != null && response.data is Map<String, dynamic>) {
            _user = User.fromJson(response.data);

            // Simpan data pengguna ke secure storage
            await secureStorage.write(key: 'user_id', value: _user?.userId.toString());
            await secureStorage.write(key: 'name', value: _user?.name);
            await secureStorage.write(key: 'email', value: _user?.email);
            await secureStorage.write(key: 'access_token', value: _user?.accessToken);

            print("User ID: ${_user?.userId}");
            print("Name: ${_user?.name}");
            print("Email: ${_user?.email}");
            print("Access Token: ${_user?.accessToken}");

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login successful")),
            );

            // Navigasi ke halaman laporan dan hapus halaman login dari tumpukan navigasi
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ReportScreen(loginController: this),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Invalid response format")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login failed")),
          );
        }
      } catch (e) {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: $e")),
        );
      }
    }
  }

  User get user => _user!;

  Future<User?> getCurrentUser() async {
    try {
      String? userId = await secureStorage.read(key: 'user_id');
      String? name = await secureStorage.read(key: 'name');
      String? email = await secureStorage.read(key: 'email');
      String? token = await secureStorage.read(key: 'access_token');

      if (userId != null && name != null && email != null && token != null) {
        print('User fetched: userId=$userId, name=$name, email=$email, token=$token');
        return User(
          userId: int.parse(userId),
          name: name,
          email: email,
          accessToken: token,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      String? token = await secureStorage.read(key: 'access_token');

      if (token != null) {
        Dio dio = Dio();
        var response = await dio.get(
          '$baseUrl/auth/logout',  // Pastikan ini sesuai dengan rute backend
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode == 200) {
          // Clear secure storage
          await secureStorage.deleteAll();

          // Navigate to login screen
          Navigator.pushReplacementNamed(context, '/');
          print("Logged out successfully");

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logged out successfully")),
          );
        } else {
          print('Logout failed');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logout failed")),
          );
        }
      }
    } catch (e) {
      print('Error logging out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging out: $e")),
      );
    }
  }

}
