import 'dart:async';

import 'package:app_quick_reports/data/providers/auth_provider.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:get/get.dart';

class MiscPruebaController extends GetxController {
  late MiscPruebaController _self;
  @override
  void onInit() {
    super.onInit();
    this._self = this;
  }

  final loading = false.obs;

  @override
  void onClose() {
    super.onClose();
  }

  int j = 0;
  Future<void> launch() async {
    // final dio = Dio();

    // dio.addSentry(captureFailedRequests: true);
    final _authProvider = AuthProvider();

    loading.value = true;
    final estamos = await tryCatch(
      code: () async {
        await _authProvider.loginWithEmail('email', 'password');
      },
      onBeforeApiLoop: (error) async {
        print('onBeforeLoop ${error.runtimeType}');

        return true;
      },
      onError: (error) async {
        return true;
      },
      onFinally: () {
        print('finally');
      },
      delayApiRetries: Duration(seconds: 1),
      apiAttempts: 5,
    );
    loading.value = false;

    print('estamos $estamos');
  }
}
