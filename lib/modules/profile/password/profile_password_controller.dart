import 'package:app_quick_reports/data/providers/user_provider.dart';
import 'package:app_quick_reports/modules/auth/auth_controller.dart';
import 'package:app_quick_reports/utils/utils.dart';
import 'package:app_quick_reports/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfilePasswordController extends GetxController {
  late ProfilePasswordController _self;
  final _authX = Get.find<AuthController>();

  final loading = false.obs;

  final _userProvider = UserProvider();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final repeatNewPassword = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    this._self = this;
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onSubmitTap() async {
    if (loading.value) return; //
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      Get.focusScope?.unfocus();

      _updatePasswordUser();
    }
  }

  Future<void> _updatePasswordUser() async {
    loading.value = true;
    await tryCatch(
      self: _self,
      code: () async {
        final resp = await _userProvider.updatePassword(
          id: _authX.user!.id,
          oldpassword: oldPassword.text.trim(),
          newpassword: newPassword.text.trim(),
          repeatnewpassword: repeatNewPassword.text.trim(),
        );

        if (resp.respuesta != 'password actualizado') {
          AppSnackbar().error(message: resp.respuesta);
        } else {
          Get.back();
          AppSnackbar().success(message: resp.respuesta);
        }
      },
      onCancelRetry: () => Get.back(),
    );
    loading.value = false;
  }

  Future<bool> handleBack() async {
    if (loading.value) {
      return false;
    }
    return true;
  }

  // Validators
  String? validateField(String? text) {
    if (text == null) return 'Campo requerido';

    if (text.trim().length < 6) {
      return 'Mínimo 6 caracteres.';
    }
    return null;
  }
}
