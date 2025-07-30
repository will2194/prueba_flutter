class StateModel {
  final String clave;
  final String estado;

  StateModel({required this.clave, required this.estado});

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(clave: json['clave'], estado: json['estado']);
  }
}
