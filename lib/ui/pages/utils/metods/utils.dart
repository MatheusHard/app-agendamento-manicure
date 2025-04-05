
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_agendamento_manicure/ui/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

  class Utils {

  static const String _boolKey = 'isLoggedIn';
  ///Servidor
  static String URL_WEB_SERVICE = "http://192.99.158.20:80/api/";
  ///Local
  //static String URL_WEB_SERVICE = "http://192.168.0.7:5001/api/";

  //String URL_WEB_SERVICE = "http://avaliacoes-backend.herokuapp.com/";
  static const String IMG_KEY = 'IMAGE_KEY';

  /*static String imprimeCPF(String cpf){
    return CPFValidator.format(cpf);
  }
  static bool validarCPF(String cpf){
    return CPFValidator.isValid(cpf);
  }*/

  static String _respostaEmoji(double value){
    String url = "";
    var lista = Utils.listaUrlEmojis();

    if(value >= 0 && value < 1) url = lista[0];
    if(value >= 1 && value < 2) url = lista[1];
    if(value >= 2 && value < 3) url = lista[2];
    if(value >= 3 && value < 4) url = lista[3];
    if(value >= 4) url = lista[4];

    return url;
  }
  static List listaDimensoes(){
    return   [
      {"id": 0, "dimensao":"Família"},
      {"id": 1, "dimensao": "Saúde"},
      {"id": 2, "dimensao": "Escola"},
      {"id": 3, "dimensao": "Professores"},
      {"id": 4, "dimensao": "Estudos"},
      {"id": 5, "dimensao": "Colegas"}
    ];
  }
  static String respostaEmoji(double value){
    String url = "";
    var lista = listaUrlEmojis();

    if(value >= 1 && value < 2) url = lista[0];
    if(value >= 2 && value < 3) url = lista[1];
    if(value >= 3 && value < 4) url = lista[2];
    if(value >= 4 && value < 5) url = lista[3];
    if(value >= 5) url = lista[4];

    return url;
  }

  static Icon getIconSemaforo(double value){
    var cor;
    var icon;


    if(value >= 1 && value < 2) {cor = Colors.red; icon = Icons.arrow_drop_down;}
    if(value >= 2 && value < 3) {cor = Colors.orange; icon = Icons.arrow_drop_down;}
    if(value >= 3 && value < 4) {cor = Colors.yellow; icon = Icons.arrow_right;}
    if(value >= 4 && value < 5) {cor = Colors.green; icon = Icons.arrow_drop_up;}
    if(value >= 5) {cor = Colors.greenAccent; icon = Icons.arrow_drop_up;}
    if(value.isNaN) {cor = Colors.black; icon = Icons.arrow_left;}


    return Icon(icon, size: 25, color: cor);

  }
  static Color? getColorSemaforo(double value){
    var cor;

    if(value >= 1 && value < 2) cor = Colors.red;
    if(value >= 2 && value < 3) cor = Colors.orange;
    if(value >= 3 && value < 4) cor = Colors.yellow;
    if(value >= 4 && value < 5) cor = Colors.green;
    if(value >= 5) cor = Colors.greenAccent;
    if(value.isNaN) cor = Colors.black;
    return  cor;

  }
  static String prettyDuration(Duration duration) {
    var seconds = (duration.inMilliseconds % (60 * 1000)) / 1000;
    return '${duration.inMinutes}:${seconds.toStringAsFixed(0)}';
  }
  static String? getYoutubeThumbnail(String videoUrl) {
    final Uri? uri = Uri.tryParse(videoUrl);
    if (uri == null) {
      return null;
    }

    return 'https://img.youtube.com/vi/${uri.queryParameters['v']}/0.jpg';
  }
  static List textoEmogisYouTube(){
    return [
      'Péssimo',
      'Ruim',
      'Normal',
      'Bom',
      'Ótimo',
    ];
    }

  static List listaUrlEmojis(){
    return [
      'assets/images/Triste.png',
      'assets/images/Chateado.png',
      'assets/images/Normal.png',
      'assets/images/Feliz.png',
      'assets/images/Muito_Feliz.png'
    ];

  }

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
  /*static  final key = crypt.Key.fromUtf8('put32charactershereeeeeeeeeeeee!'); //32 chars
  static final iv = crypt.IV.fromUtf8('put16characters!'); //16 chars

//encrypt
    static String encryptAES(String text) {
      final e = crypt.Encrypter(crypt.AES(key, mode: crypt.AESMode.cbc));
      final encrypted_data = e.encrypt(text, iv: iv);
      return encrypted_data.base64;
    }

//dycrypt
    static String decryptAES(String text) {
      final e = crypt.Encrypter(crypt.AES(key, mode: crypt.AESMode.cbc));
      final decrypted_data = e.decrypt(crypt.Encrypted.fromBase64(text), iv: iv);
      return decrypted_data;
    }*/
    //SHA1
   /* static String toSha1(String byte){

      var bytes = utf8.encode(byte); // data being hashed

      var value = sha1.convert(bytes);

      return value.toString();

    }*/
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
    return DateTime(data.year, data.month, data.day, horas, minutos, 00).toIso8601String();
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
    //Get my IP:
   /* static Future<String> getIpDevice() async{
      if(await isConnected()){
        final ipv4 = await Ipify.ipv4();
        return ipv4;
      }else{
        return "";
      }
    }*/
    /***************DataHora***************/

  static DateTime getDataHora(){
  return DateTime.now();
  }
  static String getDataHoraDotNet(){
    var now = DateTime.now();
    var dateFormatted = DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    return dateFormatted;
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
  /**************Mostrar Texto**************/
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

    /*static Future<Position> getGeolocalizacao() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition();
    }*/

 /* static String generateGuide(){
    var uuid = const Uuid();
    return uuid.v4();
  }*/
  static String showDose(String value){

      String dose = "";

      switch(value) {
        case 'D1':
        dose =  '1ª Dose';
        break;
        case 'D2':
         dose =  '2ª Dose';
        break;
        case 'D3':
         dose =  '3ª Dose';
        break;
        case 'D4':
          dose =  '4ª Dose';
        break;
        case 'REF':
          dose =  'Reforço';
        break;
        case 'UNI':
          dose =  'Única';
        break;

      }
      return dose;
  }

 /* static Future<bool> saveImageToPreferences(String value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(IMG_KEY, value);
  }

  static Future<String?> getImagesFromPreferences() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(IMG_KEY);
  }*/

  static String base64String(Uint8List bytes){
    return base64Encode(bytes);
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

  /*static  Future<Recurso?> getRecursoPadrao() async {

    return Recurso(
      id: generateGuide(), tipoRecurso: 0, link: "https://www.youtube.com/watch?v=cjONzZPJONc",
        intervaloInicial: 0, intervaloFinal: 0, indicacao: "",dataAlteracao: getDataHoraDotNet(),
      dataCadastro: getDataHoraDotNet(), ativo: 1
    );
  }*/

  }














































