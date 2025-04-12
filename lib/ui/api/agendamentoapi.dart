import 'package:app_agendamento_manicure/ui/api/configurations/dio/configs.dart';
import 'package:app_agendamento_manicure/ui/models/agendamento.dart';
import 'package:app_agendamento_manicure/ui/pages/utils/metods/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../dto/agendamento_dto.dart';
import 'interfaces/iagendamentoapi.dart';

class AgendamentoApi implements IAgendamentoApi {

  BuildContext? _context;
  final Configs _customDio = Configs();
  final URL = '/agendamentos';
  final FILTRAR = '/filtrar';


  AgendamentoApi(BuildContext context) {
    _context = context;
  }

  @override
  Future<bool> addAgendamento(Agendamento a) async {

    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.

    var response = await _customDio.dio.post(URL,
                                             data: 	{
                                                      "createdAt": a.createdAt,
                                                      "updatedAt": a.updatedAt,
                                                      "finalizado": a.finalizado,
                                                      "observacao": a.observacao,
                                                      "user": {
                                                       "id": a.user?.id
                                                      },
                                                      "cliente": {
                                                       "id": a.cliente?.id
                                                      }
                                                   },
                                             options: Options(
                                             headers: {
                                                'Authorization': 'Bearer $token',
                                             },),
                                );
    return true;
  }

  @override
  Future<bool> updateAgendamento(Agendamento a) async {
    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.

    var response = await _customDio.dio.put(URL,
      data: 	{
        "id": a.id,
        "createdAt": a.createdAt,
        "updatedAt": a.updatedAt,
        "finalizado": a.finalizado,
        "observacao": a.observacao,
        "user": {
          "id": a.user?.id
        },
        "cliente": {
          "id": a.cliente?.id
        }
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },),
    );
    return response.statusCode == 200;
  }
  @override
  Future<List<Agendamento>> getList(int user_id, int cliente_id, bool finalizado) async {

    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.
    var response = await _customDio.dio.get(URL,  options: Options(
                                                            headers: {
                                                              'Authorization': 'Bearer $token',
                                                            },),);
    if (response.statusCode == 200) {
      var lista = response.data;
      // Aqui você pode fazer o mapeamento de lista para objetos Agendamento
      List<Agendamento> agendamentos = (lista as List)
          .map((json) => Agendamento.fromJson(json))
          .toList();

      return agendamentos;
    }
    return [];
  }

  @override
  Future<List<Agendamento>> getListByFilter(AgendamentoDTO a) async {
    var token = await Utils.recuperarToken(); // Pegue do localStorage, SharedPreferences, etc.
    var response = await _customDio.dio.post(
      URL+FILTRAR,
      data: 	a.toJson(),
      options: Options(
      headers: {
        'Authorization': 'Bearer $token',
      },),);
    if (response.statusCode == 200) {
      var lista = response.data;
      // Aqui você pode fazer o mapeamento de lista para objetos Agendamento
      List<Agendamento> agendamentos = (lista as List)
          .map((json) => Agendamento.fromJson(json))
          .toList();

      return agendamentos;
    }
    return [];

  }
}