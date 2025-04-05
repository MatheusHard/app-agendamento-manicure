
import '../../models/agendamento.dart';

abstract class IAgendamentoApi{
  Future<List<Agendamento>> getList(int user_id, int cliente_id, bool finalizado);
  Future<bool> addAgendamento(Agendamento agendamento);
  Future<bool> updateAgendamento(Agendamento agendamento);
}