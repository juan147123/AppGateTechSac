import 'package:app_quick_reports/data/models/empresa.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:get/instance_manager.dart';

class EmpresaProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/api/empresa';

  Future<Empresa> getById(String empresaId) async {
    final resp = await _dioClient.get('$_endpoint/$empresaId');
    final list = List<Empresa>.from(resp.map((x) => Empresa.fromJson(x)));
    if (list.isEmpty) {
      throw BusinessException('No se encontró la empresa');
    }
    return list.first;
  }
}
