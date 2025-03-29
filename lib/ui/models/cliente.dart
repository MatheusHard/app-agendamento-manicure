class Cliente {

  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? cpf;
  String? email;
  String? telephone;

  Cliente(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.cpf,
        this.email,
        this.telephone});

  Cliente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'];
    cpf = json['cpf'];
    email = json['email'];
    telephone = json['telephone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['name'] = name;
    data['cpf'] = cpf;
    data['email'] = email;
    data['telephone'] = telephone;
    return data;
  }
}
