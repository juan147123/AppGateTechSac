import 'package:app_quick_reports/data/models/detailstr.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:get/instance_manager.dart';

class DetailsTRProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/api/detailstechnicalreview';

  Future<List<DetailsTR>> getListByCompanyId(int companyId) async {
    final resp = await _dioClient.get('$_endpoint/company/$companyId');
    return List<DetailsTR>.from(resp.map((x) => DetailsTR.fromJson(x)));
  }
}
