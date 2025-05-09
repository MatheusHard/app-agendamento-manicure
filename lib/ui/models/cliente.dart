class Cliente {

  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? cpf;
  String? email;
  String? telephone;
  bool? deletado;
  String? photoName;
  String? imagemBase64;

  Cliente(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.cpf,
        this.email,
        this.telephone,
        this.deletado,
        this.photoName,
        this.imagemBase64});

  Cliente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'];
    cpf = json['cpf'];
    email = json['email'];
    telephone = json['telephone'];
    deletado = json['deletado'];
    photoName = json['photoName'];
    imagemBase64 = json['imagemBase64'];
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
    data['deletado'] = deletado;
    data['photoName'] = photoName;
    data['imagemBase64'] = imagemBase64;

    return data;
  }
}
