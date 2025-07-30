import 'dart:convert';
import 'package:prueba_flutter/core/constants.dart';
import 'package:prueba_flutter/core/network/http_client.dart';
import 'package:prueba_flutter/core/shared_prefs.dart';
import 'package:prueba_flutter/features/login/data/models/login_model.dart';
import 'package:prueba_flutter/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await httpClient.post(
      Uri.parse("$apiBaseUrl/PostToken"),
      body: {"usr": email, "psd": password},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final loginResponse = LoginModel.fromJson(json);

      await SharedPrefs.saveToken(loginResponse.token);

      return loginResponse.token;
    } else {
      throw Exception('Login fallido');
    }
  }
}
