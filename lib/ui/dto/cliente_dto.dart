import '../models/user.dart';

class ClienteDTO {
  String? createdAt;
  String? updatedAt;
  String? name;
  String? cpf;
  String? email;
  String? telephone;
  User? user;

  ClienteDTO(
      {this.createdAt,
        this.updatedAt,
        this.name,
        this.cpf,
        this.email,
        this.telephone,
        this.user});

  ClienteDTO.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'];
    cpf = json['cpf'];
    email = json['email'];
    telephone = json['telephone'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['name'] = name;
    data['cpf'] = cpf;
    data['email'] = email;
    data['telephone'] = telephone;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}


