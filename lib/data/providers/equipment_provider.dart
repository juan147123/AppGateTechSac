import 'package:app_quick_reports/data/models/equipment.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:get/instance_manager.dart';

class EquipmentProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/api/equipment';

  Future<Equipment> getById(String equipmentId) async {
    final resp = await _dioClient.get('$_endpoint/$equipmentId');
    final list = List<Equipment>.from(resp.map((x) => Equipment.fromJson(x)));
    if (list.isEmpty) {
      throw BusinessException('No se encontró el equipo');
    }
    return list.first;
  }
}
