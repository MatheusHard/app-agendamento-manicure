
import 'package:app_agendamento_manicure/ui/dto/agendamento_dto.dart';

import '../../models/agendamento.dart';

abstract class IAgendamentoApi{
  Future<List<Agendamento>> getList(int user_id, int cliente_id, bool finalizado);
  Future<List<Agendamento>> getListByFilter(AgendamentoDTO agendamentoDTO);
  Future<bool> addAgendamento(Agendamento agendamento);
  Future<bool> updateAgendamento(Agendamento agendamento);

}