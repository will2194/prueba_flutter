import 'dart:convert';

import 'package:prueba_flutter/core/constants.dart';
import 'package:prueba_flutter/core/network/http_client.dart';
import 'package:prueba_flutter/features/home/data/models/state_model.dart';
import 'package:prueba_flutter/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<List<StateModel>> getStates() async {
    final response = await httpClient.get(
      Uri.parse("$apiBaseUrl/Services/ObtenerEstadosRepublica"),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final results = decoded['results'];

      final data = results as List<dynamic>;

      return data
          .map((e) => StateModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al obtener los estados');
    }
  }
}
