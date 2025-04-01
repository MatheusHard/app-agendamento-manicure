import 'package:app_agendamento_manicure/ui/pages/agendamento_page.dart';
import 'package:app_agendamento_manicure/ui/pages/cliente_page.dart';
import 'package:app_agendamento_manicure/ui/pages/home_page.dart';
import 'package:app_agendamento_manicure/ui/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() async {




  runApp(
  MaterialApp(
    title: 'Agendamento Manicure',
    debugShowCheckedModeBanner: false,
    routes: {
      '/home_page': (BuildContext context) => HomePage(null),
      '/cliente_page': (BuildContext context) => ClientePage(null),
      '/agendamento_page': (BuildContext context) => AgendamentoPage(null),
      '/login_page': (BuildContext context) =>  LoginPage(),

    },
    initialRoute: '/login_page',
  )

  );
}


