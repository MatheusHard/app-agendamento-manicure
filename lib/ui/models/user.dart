
class User {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? username;
  String? email;
  String? password;
  List<String>? roles;

  User(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.username,
        this.email,
        this.password,
        this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    username = json['username'] ?? "";
    email = json['email'] ?? "";
    password = json['password'] ?? "";
    roles = json['roles'] != null ? List<String>.from(json['roles']) : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['roles'] = roles;
    return data;
  }
}
