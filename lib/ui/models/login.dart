import 'user.dart';

class Login {
  String? login;
  String? token;
  User? user;

  Login({this.login, this.token, this.user});

  Login.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['login'] = login;
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}