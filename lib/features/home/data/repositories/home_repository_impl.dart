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
      final jsonList = jsonDecode(response.body) as List;
      return jsonList.map((e) => StateModel.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener los estados');
    }
  }
}
