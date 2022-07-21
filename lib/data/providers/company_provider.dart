import 'package:app_quick_reports/data/models/company.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:get/get.dart';

class CompanyProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/api/company';

  Future<CompanyEmployee> getEmployeeById(String employeeId) async {
    final resp = await _dioClient.get('$_endpoint/employeeId/$employeeId');
    final list = List<CompanyEmployee>.from(
        resp.map((x) => CompanyEmployee.fromJson(x)));
    if (list.isEmpty) {
      throw BusinessException('No se encontró el empleado');
    }
    return list.first;
  }
}
