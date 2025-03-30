import '../../models/login.dart';

abstract class ILoginApi{
  Future<bool> login(String username, String password, bool isChecked);
}