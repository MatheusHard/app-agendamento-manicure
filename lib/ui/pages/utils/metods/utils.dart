
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_agendamento_manicure/ui/models/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

  class Utils {

  static const String _boolKey = 'isLoggedIn';
  ///Servidor
  static String URL_UPLOAD = "uploads/";

  ///Local
  //static String URL_WEB_SERVICE = "http://192.168.0.7:5001/api/";
  static const String IMG_KEY = 'IMAGE_KEY';
  static bool invalidEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return true;
    } else{
      return false;
    }
  }
  ///Token
  static Future<void> salvarToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> recuperarToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  ///Salvar User
  static Future<void> salvarUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }
  //Salvar manter Conectado
  static Future<void> salvarManterConectado(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_boolKey, valor);
  }
  //Ler manter Conectado
  static Future<bool> recuperarManterConectado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_boolKey) ?? false; // false como default
  }
  ///Recuperar User
  static Future<User?> recuperarUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    }
    return null;
  }
  static Future<void> removerUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
  static String generateDataHora(DateTime data, int horas, int minutos){
    return DateTime(data.year, data.month, data.day, horas, minutos, 10).toIso8601String();
  }

  static int generateHourOfDate(String? dataString){
    DateTime data = DateTime.parse(dataString!);
    return data.hour;
  }

  static int generateMinutesOfDate(String? dataString){
    DateTime data = DateTime.parse(dataString!);
    return data.minute;
  }

  static String generateDataHoraSpring(){
    return DateTime.now().toIso8601String();
  }
   static Future<bool> isConnected() async {
    bool flag = false;
      try {
        final result = await InternetAddress.lookup('globo.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          flag = true;
          print('connected');
        }
        } on SocketException catch (_) {

        print('not connected');
        flag = false;
        }
        return flag;
    }

  ///DataHora
  static String getDataHora(){
    return DateTime.now().toIso8601String();
  }
  static DateTime? stringToDate(String dataHora){
    return DateTime.tryParse(dataHora);
  }
  static String formatarData(String data, bool small){

    final DateTime dt = DateTime.parse(data);

    final String dia = dt.day.toString().padLeft(2, '0');
    final String mes = dt.month.toString().padLeft(2, '0');
    final String ano = dt.year.toString();
    final String hora = dt.hour.toString().padLeft(2, '0');
    final String minuto = dt.minute.toString().padLeft(2, '0');

    return small
        ? "$dia/$mes/$ano"
        : "$dia/$mes/$ano $hora:$minuto";

  }
  ///Mostrar Texto
  static void showDefaultSnackbar(BuildContext context, String texto){
  //Scaffold.of(context).showSnackBar(
    final snackBar = SnackBar(
      content: Text((texto.isEmpty) ? "" : texto.toString()),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
  );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  static Future<String> base64String(Future<Uint8List> bytes) async {
    return base64Encode(await bytes);
  }
  static String formatarDateTime(DateTime? data){
      if(data != null ){
        if(data.month < 10 && data.day < 10){
          return '0${data.day}/0${data.month}/${data.year}';
        }else if(data.day >= 10 && data.month < 10){
          return '${data.day}/0${data.month}/${data.year}';
        }else if(data.day < 10 && data.month >= 10){
          return '0${data.day}/${data.month}/${data.year}';
        }else{
          return '${data.day}/${data.month}/${data.year}';
        }
      }
      return data.toString();
  }
  static SizedBox sizedBox(double largura, double altura) {
    return SizedBox(
      width: largura,
      height: altura,
    );
  }
  static Image imageFromBase64String(String bytes){
    return Image.memory(

        base64Decode(bytes),
        height: 80.0,
        width: 80.0,
        fit: BoxFit.fill,
        alignment: Alignment.center,

        );
  }
  static Uint8List fileFromBase64String(String bytes)=> base64.decode(bytes);

}














































