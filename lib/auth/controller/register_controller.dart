import 'package:Webcare/config.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../login_screen.dart';

class RegisterController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String username;
  late String email;
  late String password;
  bool isLoading = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confpasswordController = TextEditingController();

  Future<void> submit(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;

      print('Form validated successfully');

      Dio dio = Dio();
      var data = {
        "username": usernameController.text,
        "email": emailController.text,
        "password": passwordController.text,
      };

      try {
        Dio dio = Dio();
        isLoading = false;
        var response = await dio.post('$baseUrl/register', data: data);

        print(response.data);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } catch (error) {
        isLoading = false;

        print("Error: $error");

      }
    } else {
      print('Form validation failed');
    }
  }
}
