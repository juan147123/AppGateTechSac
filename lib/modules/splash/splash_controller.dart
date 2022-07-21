import 'package:app_quick_reports/modules/auth/auth_controller.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final authX = Get.find<AuthController>();
  late Image logoWhiteCache;
  late Image loginBgCache;

  final logoCacheLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    logoWhiteCache = Image.asset('assets/img/logo_white.png');
    loginBgCache = Image.asset('assets/img/login_background.jpg');

    _preloadAndAnalyzeSession();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> _preloadAndAnalyzeSession() async {
    await precacheImage(logoWhiteCache.image, Get.context!);
    logoCacheLoaded.value = true;

    await Helpers.sleep(1500);

    await precacheImage(loginBgCache.image, Get.context!);

    authX.handleUserStatus();
  }
}
