import '../models/cliente.dart';
import '../models/user.dart';

class AgendamentoDTO {
  int? id;
  String? createdAt;
  String? updatedAt;
  bool? finalizado;
  User? user;
  Cliente? cliente;
  String? observacao;
  String? dataInicial;
  String? dataFinal;

  AgendamentoDTO(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.finalizado,
        this.user,
        this.cliente,
        this.observacao,
        this.dataInicial,
        this.dataFinal});

  AgendamentoDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    finalizado = json['finalizado'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    cliente =
    json['cliente'] != null ? new Cliente.fromJson(json['cliente']) : null;
    observacao = json['observacao'];
    dataInicial = json['dataInicial'];
    dataFinal = json['dataFinal'];
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
    if (this.cliente != null) {
      data['cliente'] = cliente!.toJson();
    }
    data['observacao'] = observacao;
    data['dataInicial'] = dataInicial;
    data['dataFinal'] = dataFinal;
    return data;
  }
}
