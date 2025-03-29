import 'package:app_agendamento_manicure/ui/api/configurations/dio/configs.dart';
import 'package:app_agendamento_manicure/ui/api/interfaces/iloginapi.dart';
import 'package:app_agendamento_manicure/ui/models/login.dart';
import 'package:flutter/material.dart';

import '../pages/screen_arguments/ScreenArgumentsUser.dart';
import '../pages/utils/metods/utils.dart';

class LoginApi implements ILoginApi{

  BuildContext? _context;

  LoginApi(BuildContext context){
    _context = context;
  }

  @override
  Future<bool> login(String username, String password) async {

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
          await Utils.salvarToken(login.token ?? "");
          flag = true;
          Navigator.pushNamed(_context!, '/home_page', arguments: ScreenArgumentsUser(login));
        }
      }
    }catch(error){
      Utils.showDefaultSnackbar(_context!, '''Verifique suas credenciais!!!''');
      flag = false;
    }

    return flag;
  }


}