
import 'package:app_agendamento_manicure/ui/models/cliente.dart';

abstract class IClienteApi{
  Future<List<Cliente>> getList(int user_id, int cliente_id);
  Future<bool> addCliente(Cliente cliente, int user_id);
  Future<bool> updateCliente(Cliente cliente, int user_id);
}