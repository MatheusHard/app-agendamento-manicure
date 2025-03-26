import '../../models/Login.dart';

abstract class ILoginApi{
  Future<bool> getToken(String username, String password);
}