import 'dart:typed_data';

import 'package:app_quick_reports/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';

class PdfProvider {
  final DioClient _dioClient = Get.find<DioClient>();

  final String _endpoint = '/api/detailstechnicalreviewallpdfapp';

  Future<Uint8List> getDetailsPDF({
    required String technicalReviewId,
    ProgressCallback? onReceiveProgress,
  }) async {
    final resp = await _dioClient.get(
      '$_endpoint/$technicalReviewId',
      onReceiveProgress: onReceiveProgress,
      options: Options(
        responseType: ResponseType.bytes,
        receiveTimeout: 60000,
      ),
    );

    /* final dio = Dio();
    final exDio = DioClient('https://www.eafit.edu.co/', dio);
    final resp = await exDio.get(
      '/bogota/acerca-de-eafit-bogota/Documents/hola-mundo.pdf',
      onReceiveProgress: onReceiveProgress,
      options: Options(
        responseType: ResponseType.bytes,
        receiveTimeout: 60000,
      ),
    ); */
    final responseBytes = resp as List<int>;
    return responseBytes as Uint8List;
  }
}
