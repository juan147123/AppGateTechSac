import 'package:app_quick_reports/data/models/user_credentials.dart';
import 'package:app_quick_reports/data/providers/auth_provider.dart';
import 'package:app_quick_reports/modules/auth/auth_controller.dart';
import 'package:app_quick_reports/modules/misc/error/misc_error_controller.dart';
import 'package:app_quick_reports/routes/app_pages.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginFormController extends GetxController {
  late LoginFormController _self;

  final _authX = Get.find<AuthController>();
  final _authProvider = AuthProvider();

  final emailCtlr = TextEditingController();
  final passwordCtlr = TextEditingController();

  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    this._self = this;
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onLoginButtonTap() {
    if (loading.value) return;

    if (_validateEmail() != null) {
      AppSnackbar().warning(message: _validateEmail() ?? '');
      return;
    }

    if (_validatePassword() != null) {
      AppSnackbar().warning(message: _validatePassword() ?? '');
      return;
    }

    Get.focusScope?.unfocus();
    _login();
  }

  Future<void> _login() async {
    UserCredentials? credentials;
    String? errorMsg;
    try {
      loading.value = true;
      await Helpers.sleep(1500);
      final resp = await _authProvider.loginWithEmail(
        emailCtlr.text.trim(),
        passwordCtlr.text.trim(),
      );
      if (resp == null) {
        AppSnackbar().error(message: 'Contraseña incorrecta');
      } else {
        credentials = resp;
      }
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } on BusinessException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado en el login';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        _login();
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;

      if (credentials != null) {
        // Guarda las credenciales en memoria y storage
        await _authX.saveUserCredentialsInStore(credentials);
        _authX.handleUserStatus();
      }
    }
  }

  void onResetPasswordTap() {
    if (loading.value) return;

    _resetPassword();
  }

  Future<void> _resetPassword() async {
    Get.focusScope?.unfocus();
    Get.toNamed(AppRoutes.LOGIN_LOST_PASSWORD);
  }

  // Validators
  String? _validateEmail() {
    if (emailCtlr.text.trim().isEmail) {
      return null;
    }
    return 'Email no válido';
  }

  String? _validatePassword() {
    if (passwordCtlr.text.trim().length >= 3) {
      return null;
    }
    return 'Contraseña requerida';
  }
}
