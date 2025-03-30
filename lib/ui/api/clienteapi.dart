
import 'package:app_agendamento_manicure/ui/models/cliente.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../pages/utils/metods/utils.dart';
import 'configurations/dio/configs.dart';
import 'interfaces/iclienteapi.dart';

class ClienteApi implements IClienteApi {

  BuildContext? _context;
  Configs _customDio = Configs();
  final URL = "/clientes";

  ClienteApi(BuildContext context) {
    _context = context;
  }

  @override
  Future<bool> addCliente(Cliente cliente, int user_id) async {
    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.

    var response = await _customDio.dio.post(URL,
      data: {
        "name": cliente.name,
        "createdAt": cliente.createdAt,
        "updatedAt": cliente.updatedAt,
        "name": cliente.name,
        "cpf": cliente.cpf,
        "email": cliente.email,
        "telephone": cliente.telephone,
        "user": {
          "id":  user_id
        }
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },),
    );

    if(response.status == 200 || response.status == 201) Utils.showDefaultSnackbar(_context!, "Cliente cadastrado com sucesso!!!");

    return true;
  }

  @override
  Future<List<Cliente>> getList(int user_id, int cliente_id) async {
    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.
    var response = await _customDio.dio.get(URL,  options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },),);
    if (response.statusCode == 200) {
      var lista = response.data;
      // Aqui você pode fazer o mapeamento de lista para objetos Cliente
      List<Cliente> clientes = (lista as List)
          .map((json) => Cliente.fromJson(json))
          .toList();

      return clientes;
    }

    return [];
  }

  @override
  Future<bool> updateCliente(Cliente cliente, int user_id) {
    // TODO: implement updateCliente
    throw UnimplementedError();
  }
}