import 'package:app_agendamento_manicure/ui/models/user.dart';

import 'cliente.dart';

class Agendamento {
  int? id;
  String? createdAt;
  String? updatedAt;
  bool? finalizado;
  User? user;
  Cliente? cliente;
  String? observacao;

  Agendamento(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.finalizado,
        this.user,
        this.cliente,
        this.observacao});

  Agendamento.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    finalizado = json['finalizado'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    cliente =
    json['cliente'] != null ? Cliente.fromJson(json['cliente']) : null;
    observacao = json['observacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['finalizado'] = finalizado;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (cliente != null) {
      data['cliente'] = cliente!.toJson();
    }
    data['observacao'] = observacao;
    return data;
  }
}