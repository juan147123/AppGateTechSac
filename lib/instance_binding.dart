import 'package:app_quick_reports/config/config.dart';
import 'package:app_quick_reports/modules/auth/auth_controller.dart';
import 'package:app_quick_reports/modules/prefs/prefs_controller.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class InstanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PrefsController());

    Get.put(AuthController());

    final Dio dio = Dio();

    Get.put(DioClient(
      Config.URL_API,
      dio,
      interceptors: [
        AppInterceptors(),
        /* if (kDebugMode)
          PrettyDioLogger(
              requestHeader: true,
              requestBody: true,
              responseBody: true,
              responseHeader: false,
              error: true,
              compact: true,
              maxWidth: 90) */
      ],
    ));
  }
}

// token expirado eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE2NDkxMjAwMzUsImV4cCI6MTY0OTEzNDQzNSwiZGF0YSI6eyJpZCI6IjE5IiwiZW1haWwiOiJwcnVlYmFAZ21haWwuY29tIiwicm9sIjoiRW1wcmVzYSJ9fQ.7beRrumaxV6KYEr1LBgr6xcmQIM3M3aV959xoqjPw4va-EreDzo1yCqTq81lMukqehPcy849zzH1wfpgCveXZw

class AppInterceptors extends InterceptorsWrapper {
  final _authX = Get.find<AuthController>();

  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (_authX.userCredentials != null) {
      options.headers["Authorization"] =
          'Bearer ${_authX.userCredentials!.token}';
    }

    return super.onRequest(options, handler);
  }

  @override
  onResponse(dynamic response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      AppSnackbar()
          .error(message: 'Sesión caducada!\nInicie sesión nuevamente');
      _authX.logout();
    } else {
      super.onError(err, handler);
    }
  }
}
