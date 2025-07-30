import 'package:prueba_flutter/features/home/data/models/state_model.dart';

abstract class HomeRepository {
  Future<List<StateModel>> getStates();
}
