import 'package:app_quick_reports/data/models/user.dart';
import 'package:app_quick_reports/data/models/user_credentials.dart';
import 'package:app_quick_reports/modules/prefs/prefs_controller.dart';
import 'package:app_quick_reports/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthController extends GetxController {
  final _prefsX = Get.find<PrefsController>();

  TargetPlatform platform = TargetPlatform.android;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );
  PackageInfo get packageInfo => this._packageInfo;

  UserCredentials? _userCredentials;
  UserCredentials? get userCredentials => this._userCredentials;

  User? _user;
  User? get user => this._user;

  void setUser(User? data) => _user = data;

  // Getbuilders Id's
  final gbMenuDrawer = 'gbMenuDrawer';

  @override
  void onInit() {
    super.onInit();

    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;
  }

  // Almacena las credenciales en las preferencias del usuario y en memoria del
  // controlar Auth.
  Future<void> saveUserCredentialsInStore(UserCredentials? credentials) async {
    this._userCredentials = credentials;
    await _prefsX.setUserCredentialStored(credentials);
  }

  Future<void> handleUserStatus() async {
    final credentialsFromPrefs = _prefsX.userCredentialStored;
    if (credentialsFromPrefs != null) {
      this._userCredentials = credentialsFromPrefs;
    }

    if (_userCredentials != null) {
      Get.offAllNamed(AppRoutes.HOME);
    } else {
      Get.offAllNamed(AppRoutes.LOGIN_FORM);
    }
  }

  void logout() async {
    await saveUserCredentialsInStore(null);
    setUser(null);
    await _prefsX.deleteAll();

    handleUserStatus();
  }

  void refreshMenuDrawer() {
    update([gbMenuDrawer]);
  }
}
