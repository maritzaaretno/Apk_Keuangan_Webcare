import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/user_model.dart';
import '../../config.dart';

class ProfileController {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  User? _user;

  Future<User?> getUserProfile() async {
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
}
