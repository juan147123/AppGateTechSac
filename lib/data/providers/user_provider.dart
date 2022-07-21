import 'package:app_quick_reports/data/models/password.dart';
import 'package:app_quick_reports/data/models/user.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:get/instance_manager.dart';

class UserProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/api/user';

  Future<User> getUserById(String userId) async {
    final resp = await _dioClient.get('$_endpoint/$userId');
    final list = List<User>.from(resp.map((x) => User.fromJson(x)));

    if (list.isEmpty) {
      throw BusinessException('No se encontró el usuario');
    }

    return list.first;
  }

  Future<UpdatePasswordResponse> updatePassword({
    required String id,
    required String oldpassword,
    required String newpassword,
    required String repeatnewpassword,
  }) async {
    final resp = await _dioClient.put('/api/updatepassword', data: {
      "id": id,
      "oldpassword": oldpassword,
      "newpassword": newpassword,
      "repeatnewpassword": repeatnewpassword
    });
    return UpdatePasswordResponse.fromJson(resp);
  }
}
