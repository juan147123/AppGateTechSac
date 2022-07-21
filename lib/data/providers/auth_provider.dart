import 'package:app_quick_reports/data/models/user_credentials.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:get/instance_manager.dart';

class AuthProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  Future<UserCredentials?> loginWithEmail(String email, String password) async {
    final resp = await _dioClient.post('/login', data: {
      'email': email,
      'password': password,
    });

    if (resp['token'] != null) {
      return UserCredentials.fromJson(resp);
    }
    return null;
  }

  Future<bool> recoverPassword(String email) async {
    final resp = await _dioClient.post('/passrecovery', data: {'email': email});
    return resp['Error'] == null;
  }
}
