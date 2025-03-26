import 'package:app_agendamento_manicure/ui/api/configurations/dio/configs.dart';
import 'package:app_agendamento_manicure/ui/api/interfaces/iloginapi.dart';
import 'package:app_agendamento_manicure/ui/models/Login.dart';
import 'package:app_agendamento_manicure/ui/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../pages/utils/metods/utils.dart';

class LoginApi implements ILoginApi{

  BuildContext? _context;

  LoginApi(BuildContext context){
    _context = context;
  }

  @override
  Future<bool> getToken(String username, String password) async {

    bool flag = false;
    var customDio = Configs();

    try{
      var response = await customDio.dio.post("/login", data: {
        "username": username,
        "password": password
      });

      if(response.statusCode == 200){
        Login login =  Login.fromJson(response.data);
        if(login.token != null){
          flag = true;
          Navigator.push(
              _context!,
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    }catch(error){
      Utils.showDefaultSnackbar(_context!, '''Verifique suas credenciais!!!''');
      flag = false;
    }

    return flag;
  }


}