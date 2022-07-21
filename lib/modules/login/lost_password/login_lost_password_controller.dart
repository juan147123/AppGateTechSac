import 'package:app_quick_reports/data/providers/auth_provider.dart';
import 'package:app_quick_reports/modules/misc/error/misc_error_controller.dart';
import 'package:app_quick_reports/routes/app_pages.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginLostPasswordController extends GetxController {
  late LoginLostPasswordController _self;
  final _authProvider = AuthProvider();

  final emailCtlr = TextEditingController();

  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    this._self = this;
  }

  void onSendButtonTap() {
    if (loading.value) return;

    if (_validateEmail() != null) {
      AppSnackbar().warning(message: _validateEmail() ?? '');
      return;
    }

    Get.focusScope?.unfocus();
    _sendEmail();
  }

  Future<void> _sendEmail() async {
    String? errorMsg;
    bool sendSuccess = false;
    try {
      loading.value = true;
      await Helpers.sleep(1500);
      sendSuccess = await _authProvider.recoverPassword(emailCtlr.text.trim());
    } on ApiException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } on BusinessException catch (e) {
      errorMsg = e.message;
      Helpers.logger.e(e.message);
    } catch (e) {
      errorMsg = 'Ocurrió un error inesperado recuperando la contraseña';
      Helpers.logger.e(e.toString());
    }

    if (_self.isClosed) return;
    if (errorMsg != null) {
      final ers = await Get.toNamed(AppRoutes.MISC_ERROR,
          arguments: MiscErrorArguments(content: errorMsg));
      if (ers == MiscErrorResult.retry) {
        await Helpers.sleep(1500);
        _sendEmail();
      } else {
        loading.value = false;
      }
    } else {
      loading.value = false;

      if (sendSuccess) {
        Get.back();
        AppSnackbar().success(
            message: 'Enlace enviado!\nRevisa tu bandeja de entrada.',
            duration: Duration(seconds: 5));
      } else {
        AppSnackbar().error(
            message:
                'No se pudo enviar el enlace. Puede que el correo no exista.');
      }
    }
  }

  Future<bool> handleBack() async {
    if (loading.value) {
      return false;
    }
    return true;
  }

  // Validators
  String? _validateEmail() {
    if (emailCtlr.text.trim().isEmail) {
      return null;
    }
    return 'Email no válido';
  }
}
